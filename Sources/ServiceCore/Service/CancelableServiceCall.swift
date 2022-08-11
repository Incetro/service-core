//
//  CancelableServiceCall.swift
//  TheRun
//
//  Created by incetro on 3/23/20.
//  Copyright © 2020 Incetro Inc. All rights reserved.
//

import Foundation
import Combine

// MARK: - CancelableServiceCall

/// Wrapper over service method. Might be called synchronously or asynchronously
final public class CancelableServiceCall<Payload> {

    /// Signature for closure, which wraps service method logic
    public typealias Main = (_ this: CancelableServiceCall<Payload>, _ callback: @escaping Callback) throws -> Void

    /// Completion callback signature
    public typealias Callback = (_ result: Result<Payload, Error>) -> Void

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
    public func run() -> ServiceCallResult<Payload> {
        let completion = ServiceCallResult<Payload>()
        self.operationQueue.addOperation {
            do {
                try self.main(self) { (result: Result<Payload, Error>) -> Void in
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
            cancelClosure?()
        }
        return nil != cancelClosure
    }

    /// Run on publisher
    @available(iOS 13.0, *)
    @discardableResult public func publish() -> AnyPublisher<Payload, NSError> {
        Future { completion in
            self.operationQueue.addOperation {
                do {
                    try self.main(self) { (result: Result<Payload, Error>) -> Void in
                        self.result = result
                        self.callbackQueue.addOperation {
                            switch result {
                            case .success(let payload):
                                completion(.success(payload))
                            case .failure(let error):
                                completion(.failure(error as NSError))
                            }
                        }
                    }
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
