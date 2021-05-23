//
//  Service.swift
//  TheRun
//
//  Created by incetro on 3/21/20.
//  Copyright © 2020 Incetro Inc. All rights reserved.
//

import Foundation

// MARK: - Service

/// Base service class
open class Service {

    /// Background working queue
    public let operationQueue: OperationQueue

    /// Main queue for callbacks
    public let completionQueue: OperationQueue

    /// Default initializer
    /// - Parameters:
    ///   - operationQueue: background working queue
    ///   - completionQueue: main queue for callbacks
    public init(
        operationQueue: OperationQueue = OperationQueue(),
        completionQueue: OperationQueue = OperationQueue.main
    ) {
        self.operationQueue = operationQueue
        self.completionQueue = completionQueue
    }

    /// Assemble a sync/async call object.
    /// - Parameter main: main execution method
    open func createCall<Payload>(main: @escaping ServiceCall<Payload>.Main) -> ServiceCall<Payload> {
        ServiceCall(
            operationQueue: operationQueue,
            callbackQueue: completionQueue,
            main: main
        )
    }

    /// Assemble a async call object.
    /// - Parameter main: main execution method
    open func createCancelableCall<Payload>(main: @escaping CancelableServiceCall<Payload>.Main) -> CancelableServiceCall<Payload> {
        CancelableServiceCall(
            operationQueue: operationQueue,
            callbackQueue: completionQueue,
            main: main
        )
    }
}
