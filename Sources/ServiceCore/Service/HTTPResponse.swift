//
//  HTTPResponse.swift
//  TheRun
//
//  Created by incetro on 7/24/20.
//  Copyright © 2020 Incetro Inc. All rights reserved.
//

import HTTPTransport

public typealias ServiceCoreParameters = [String: Any]

// MARK: - HTTPResponse

public extension HTTPResponse {

    func dictionary(_ key: String) throws -> ServiceCoreParameters {
        try getJSONDictionary()
            .unwrap()[key]
            .unwrap(as: ServiceCoreParameters.self)
    }

    func array(_ key: String) throws -> [ServiceCoreParameters] {
        (try getJSONDictionary().unwrap()[key] as? [ServiceCoreParameters]) ?? [ServiceCoreParameters]()
    }
}
