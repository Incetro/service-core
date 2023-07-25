//
//  WebService.swift
//  TheRun
//
//  Created by incetro on 3/21/20.
//  Copyright © 2020 Incetro Inc. All rights reserved.
//

import HTTPTransport
import Foundation

// MARK: - WebService

open class WebService: Service {

    /// Web service root
    public let baseURL: URL

    /// Default request headers
    public let headers: [String: String]

    /// Request interceptors for all requests.
    public let requestInterceptors: [HTTPRequestInterceptor]

    /// Response interceptors for all requests.
    public let responseInterceptors: [HTTPResponseInterceptor]

    /// Transport for requests
    public let transport: HTTPTransport

    /// Base request
    public var baseRequest: HTTPRequest {
        HTTPRequest(
            endpoint: baseURL.absoluteString,
            headers: headers,
            requestInterceptors: requestInterceptors,
            responseInterceptors: responseInterceptors
        )
    }

    /// Empty JSON parameters
    public var jsonParameters: HTTPRequestParameters {
        HTTPRequestParameters(parameters: [:], encoding: .json)
    }

    /// Empty URL parameters
    public var urlParameters: HTTPRequestParameters {
        HTTPRequestParameters(parameters: [:], encoding: .url)
    }

    /// Default initializer
    /// - Parameters:
    ///   - operationQueue: background working queue
    ///   - completionQueue: main queue for callbacks
    ///   - baseURL: base url address
    ///   - transport: Transport for requests
    ///   - requestInterceptors: request interceptors
    ///   - responseInterceptors: response interceptors
    ///   - headers: default request headers
    public init(
        operationQueue: OperationQueue = OperationQueue(),
        completionQueue: OperationQueue = OperationQueue.main,
        baseURL: URL,
        transport: HTTPTransport,
        requestInterceptors: [HTTPRequestInterceptor] = [],
        responseInterceptors: [HTTPResponseInterceptor] = [],
        headers: [String: String] = [:]
    ) {
        self.baseURL = baseURL
        self.transport = transport
        self.requestInterceptors = requestInterceptors
        self.responseInterceptors = responseInterceptors
        self.headers = headers
        super.init(operationQueue: operationQueue, completionQueue: completionQueue)
    }

    /// Allowing to fill HTTPRequestParameters with optional values
    public func fillHTTPRequestParameters(
        _ httpRequestParameters: HTTPRequestParameters,
        with parameters: [String: Any?]
    ) -> HTTPRequestParameters {
        parameters.forEach { (parameter: (name: String, value: Any?)) in
            if let value: Any = parameter.value {
                httpRequestParameters[parameter.name] = value
            }
        }
        return httpRequestParameters
    }
}
