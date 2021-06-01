//
//  ApiRequestType.swift
//  ProductViewer
//
//  Created by Banisetty Avinash on 6/1/21.
//  Copyright © 2021 Target. All rights reserved.
//

import Foundation

public typealias Parameters = [String: Any]
public typealias Headers = [String: String]

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

public enum HTTPParameterUtil {
    case defaultParameter
    case parameters(bodyParams: Parameters?, bodyEncoding: ParameterEncoder, urlParams: Parameters?)
    case parametersWithHeaders(bodyParams: Parameters?, bodyEncoding: ParameterEncoder, urlParams: Parameters?, headers: Headers)
}

protocol APIRequestType {
    var baseURL: URL { get }
    var apiPath: String { get }
    var httpMethod: HTTPMethod { get }
    var makeParams: HTTPParameterUtil { get }
    var headers: Headers? { get }
}
