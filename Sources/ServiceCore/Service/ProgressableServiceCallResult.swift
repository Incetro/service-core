//
//  ProgressableServiceCallResult.swift
//  ServiceCore IOS
//
//  Created by Dmitry Savinov on 31.10.2022.
//

import Foundation

// MARK: - ProgressableServiceCallResult

final public class ProgressableServiceCallResult<Payload> {

    // MARK: - Aliases

    public typealias Success = (Payload) -> Void
    public typealias Failure = (Error) -> Void
    public typealias ProgressClosure = (Progress) -> Void

    // MARK: - Properties

    /// Success block
    private(set) var successClosure: Success?

    /// Failure block
    private(set) var failureClosure: Failure?

    /// Progress block
    private(set) var progressClosure: ProgressClosure?

    // MARK: - Initializers

    init() {
        successClosure = nil
        failureClosure = nil
        progressClosure = nil
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

    @discardableResult public func progress(_ block: ProgressClosure?) -> Self {
        progressClosure = block
        return self
    }
}
