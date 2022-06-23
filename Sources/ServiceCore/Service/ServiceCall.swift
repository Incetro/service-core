//
//  ServiceCall.swift
//  TheRun
//
//  Created by incetro on 3/21/20.
//  Copyright © 2020 Incetro Inc. All rights reserved.
//

import Foundation
import Combine

// MARK: - ServiceCall

/// Wrapper over service method. Might be called synchronously or asynchronously
public final class ServiceCall<Payload> {

    /// Signature for closure, which wraps service method logic
    public typealias Main = () throws -> Result<Payload, Error>

    /// Background queue, where wrapped service logic will be performed
    private let operationQueue: OperationQueue

    /// Completion callback queue
    private let callbackQueue: OperationQueue

    /// Closure, which wraps service method logic
    private let main: Main

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

    /// Run synchronously
    @discardableResult public func sync() -> Result<Payload, Error> {
        do {
            let result = try main()
            let payload = try result.get()
            return .success(payload)
        } catch {
            return .failure(error)
        }
    }

    /// Run in background
    @discardableResult public func async() -> ServiceCallResult<Payload> {
        let completion = ServiceCallResult<Payload>()
        operationQueue.addOperation {
            do {
                let result = try self.main()
                let payload = try result.get()
                self.callbackQueue.addOperation {
                    completion.successClosure?(payload)
                }
            } catch {
                self.callbackQueue.addOperation {
                    completion.failureClosure?(error)
                }
            }
        }
        return completion
    }

    /// Run on publisher
    @available(iOS 13.0, *)
    @discardableResult public func publish() -> AnyPublisher<Payload, NSError> {
        Deferred {
            Future { completion in
                self.operationQueue.addOperation {
                    do {
                        let result = try self.main()
                        let payload = try result.get()
                        self.callbackQueue.addOperation {
                            completion(.success(payload))
                        }
                    } catch {
                        self.callbackQueue.addOperation {
                            completion(.failure(error as NSError))
                        }
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
