//
//  ServiceCallResult.swift
//  TheRun
//
//  Created by incetro on 3/23/20.
//  Copyright © 2020 Incetro Inc. All rights reserved.
//

import Foundation

// MARK: - ServiceCallResult

final public class ServiceCallResult<Payload> {

    // MARK: - Aliases

    public typealias Success = (Payload) -> Void
    public typealias Failure = (Error) -> Void

    // MARK: - Properties

    /// Success block
    private(set) var successClosure: Success?

    /// Failure block
    private(set) var failureClosure: Failure?

    // MARK: - Initializers

    init() {
        successClosure = nil
        failureClosure = nil
    }

    // MARK: - Useful

    @discardableResult public func success(_ block: Success?) -> Self {
        successClosure = block
        return self
    }

    @discardableResult public func failure(_ block: Failure?) -> Self {
        failureClosure = block
        return self
    }
}
