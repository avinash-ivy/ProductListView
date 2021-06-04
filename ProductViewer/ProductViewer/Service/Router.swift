//
//  Router.swift
//  ProductViewer
//
//  Created by Banisetty Avinash on 6/1/21.
//  Copyright © 2021 Target. All rights reserved.
//

import Foundation

enum APIError: Error {
    case invalidDataError
    case codingError
    case invalidResponseCode
    case mockDataSerializationError
}

protocol Router: class {
    associatedtype ApiRequest: APIRequestType
    func request(withApiRequest route: ApiRequest, completion: @escaping (_ data: Data?,_ response: URLResponse?,_ error: Error?) -> ())
}

class NetworkRouter<ApiRequest: APIRequestType>: Router {
    
    private var urlSessionTask: URLSessionTask?
    
    func request(withApiRequest route: ApiRequest, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let urlSession = URLSession.shared
        
        do {
            let request = try buildURLRequest(fromAPIRequest: route)
            urlSessionTask = urlSession.dataTask(with: request, completionHandler: { (data, response, error) in
                
                if let urlResponse = response as? HTTPURLResponse {
                    
                    switch urlResponse.statusCode {
                    case 200 ... 299:
                        // Valid HTTP Response
                        completion(data, urlResponse, error)
                    default:
                        completion(nil, urlResponse, APIError.invalidResponseCode)
                    }
                }
            })
        } catch  {
            completion(nil, nil, error)
        }
        urlSessionTask?.resume()
    }
    
    func buildURLRequest(fromAPIRequest apiRequest: ApiRequest) throws -> URLRequest {
        let completeURL = apiRequest.baseURL.appendingPathComponent(apiRequest.apiPath)
        var request = URLRequest(url: completeURL,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        request.httpMethod = apiRequest.httpMethod.rawValue
        
        do {
            switch apiRequest.makeParams {
            case .defaultParameter:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .parametersWithHeaders(let bodyParams, let bodyEncoding, let urlParams, let headers):
                try self.encodeParameters(bodyParameters: bodyParams, bodyEncoding: bodyEncoding, urlParameters: urlParams, request: &request)
                self.addAdditionalHeaders(headers, request: &request)
            case .parameters(let bodyParams, let bodyEncoding, let urlParams):
                try self.encodeParameters(bodyParameters: bodyParams, bodyEncoding: bodyEncoding, urlParameters: urlParams, request: &request)
            }
            return request
        } catch  {
            throw error
        }
    }
    
    func encodeParameters(bodyParameters: Parameters?,
                          bodyEncoding: ParameterEncoder,
                          urlParameters: Parameters?,
                          request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters,
                                    urlParameters: urlParameters)
        } catch  {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: Headers?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
