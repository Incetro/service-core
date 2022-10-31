//
//  ProgressableServiceCall.swift
//  ServiceCore IOS
//
//  Created by Dmitry Savinov on 31.10.2022.
//

import Foundation
import Combine

// MARK: - Progressable

public enum Progressable<Value> : Equatable where Value: Equatable {
    case progress(Progress)
    case value(Value)
}

// MARK: - ProgressableServiceCall

/// Wrapper over service method. Might be called synchronously or asynchronously
final public class ProgressableServiceCall<Payload> {

    /// Signature for closure, which wraps service method logic
    public typealias Main = (
        _ this: ProgressableServiceCall<Payload>,
        _ progress: @escaping ProgressCallback,
        _ callback: @escaping Callback
    ) throws -> Void

    /// Completion callback signature
    public typealias Callback = (_ result: Result<Payload, Error>) -> Void

    /// Progress callback signature
    public typealias ProgressCallback = (_ progress: Progress) -> Void

    /// Cancel closure signature
    public typealias Cancel = () -> Void

    /// Background queue, where wrapped service logic will be performed
    private let operationQueue: OperationQueue

    /// Completion callback queue
    private let callbackQueue: OperationQueue

    /// Closure, which wraps service method logic
    private let main: Main

    /// ServiceCall cancel closure
    public var cancelClosure: Cancel?

    /// Result
    private var result: Result<Payload, Error>?

    /// Progress
    private var progress: Progress?

    /// Default initializer
    /// - Parameters:
    ///   - operationQueue: background queue, where wrapped service logic will be performed
    ///   - callbackQueue: completion callback queue
    ///   - main: closure, which wraps service method logic
    public init(
        operationQueue: OperationQueue,
        callbackQueue: OperationQueue,
        main: @escaping Main
    ) {
        self.operationQueue = operationQueue
        self.callbackQueue = callbackQueue
        self.main = main
    }

    /// Run in background
    public func run() -> ProgressableServiceCallResult<Payload> {
        let completion = ProgressableServiceCallResult<Payload>()
        self.operationQueue.addOperation {
            do {
                try self.main(
                    self,
                    { progress in
                        self.progress = progress
                        self.callbackQueue.addOperation {
                            completion.progressClosure?(progress)
                        }
                    },
                    { result in
                        self.result = result
                        self.callbackQueue.addOperation {
                            switch result {
                            case .success(let payload):
                                completion.successClosure?(payload)
                            case .failure(let error):
                                completion.failureClosure?(error)
                            }
                        }
                    }
                )
            } catch {
                self.callbackQueue.addOperation {
                    completion.failureClosure?(error)
                }
            }
        }
        return completion
    }

    /// Cancel call's request
    @discardableResult public func cancel() -> Bool {
        defer {
            result = nil
            progress = nil
            cancelClosure?()
        }
        return nil != cancelClosure
    }
}

// MARK: - Publisher

extension ProgressableServiceCall where Payload: Equatable {

    /// Run on publisher
    @available(iOS 13.0, *)
    @discardableResult public func publish() -> AnyPublisher<Progressable<Payload>, NSError> {
        Future { completion in
            self.operationQueue.addOperation {
                do {
                    try self.main(
                        self,
                        { progress in
                            self.progress = progress
                            self.callbackQueue.addOperation {
                                completion(.success(.progress(progress)))
                            }
                        },
                        { result in
                            self.result = result
                            self.callbackQueue.addOperation {
                                switch result {
                                case .success(let payload):
                                    completion(.success(.value(payload)))
                                case .failure(let error):
                                    completion(.failure(error as NSError))
                                }
                            }
                        }
                    )
                } catch {
                    self.callbackQueue.addOperation {
                        completion(.failure(error as NSError))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
