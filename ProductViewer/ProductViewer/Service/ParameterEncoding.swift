//
//  ParameterEncoding.swift
//  ProductViewer
//
//  Created by Banisetty Avinash on 6/1/21.
//  Copyright © 2021 Target. All rights reserved.
//

import Foundation

public protocol Encoder {
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

public struct JSONParamterEncoder: Encoder {
    public func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonEncodedData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonEncodedData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch  {
            throw error
        }
    }
}

public struct URLParameterEncoder: Encoder {
    public func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        guard let url = urlRequest.url else { return }
        
        if var urlComponents = URLComponents(url: url,
                                             resolvingAgainstBaseURL: false), !parameters.isEmpty {
            
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key,value) in parameters {
                let queryItem = URLQueryItem(name: key,
                                             value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}

public enum ParameterEncoder {
    case jsonEncoder
    case urlEncoder
    case urlAndJsonEncoder
    
    public func encode(urlRequest: inout URLRequest,
                       bodyParameters: Parameters?,
                       urlParameters: Parameters?
                       ) throws {
        do {
            switch self {
            case .jsonEncoder:
                guard let bodyParams = bodyParameters else { return }
                try JSONParamterEncoder().encode(urlRequest: &urlRequest, with: bodyParams)
            case .urlEncoder:
                guard let urlParams = urlParameters else { return }
                try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParams)
            case .urlAndJsonEncoder:
                guard let bodyParams = bodyParameters,
                    let urlParams = urlParameters else { return }
                try JSONParamterEncoder().encode(urlRequest: &urlRequest, with: bodyParams)
                try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParams)
            }
        } catch  {
            throw error
        }
    }
}
