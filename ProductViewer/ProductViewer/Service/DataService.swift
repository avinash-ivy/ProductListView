//
//  DataService.swift
//  ProductViewer
//
//  Created by Banisetty Avinash on 6/1/21.
//  Copyright © 2021 Target. All rights reserved.
//

import Foundation
import Tempo

enum DataSourceType {
    case network
    case disk
    case db
    case mock
}

public enum Result<T> {
    case success(T)
    case failure(Error)
}

struct Response<T>: Decodable where T:Decodable {
    // In API Request it is products, but it may vary
    // If we want to abstract it more, then we need to introduce model inaddition to viewstate
    // TODO: Uncomment and remove duplicates - Sample API used
    private(set) var products: T?
//    private(set) var data: T?
}

protocol Service {
    func fetchData<T:Decodable>(onCompletion completionHandler: @escaping (_ result: Result<T>) -> ())
}

struct DataService:Service {
        
    let router = NetworkRouter<DealsApiRequest>()
    let dataSource: DataSourceType
    
    func fetchData<T>(onCompletion completionHandler: @escaping (Result<T>) -> ()) where T : Decodable {
        switch dataSource {
        case .mock:
            if let path = Bundle.main.path(forResource: "jsonformatter", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    //                      let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                    //                      if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let products = jsonResult["products"] as? [Any] {
                    let decodedResult = try JSONDecoder().decode(Response<T>.self, from: data)
                    if let decodedValue = decodedResult.products {
                        completionHandler(.success(decodedValue))
                    }
                }
                catch {
                    completionHandler(.failure(APIError.mockDataSerializationError))
                }
            }
        default:
            router.request(withApiRequest: DealsApiRequest()) { data, response, error in
                
                if let validError = error {
                    completionHandler(.failure(validError))
                }
                guard let responseData = data else {
                    completionHandler(.failure(APIError.invalidDataError))
                    return
                }
                do {
                    /*
                     // For debug purpose to check entire response uncomment
                     let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                     print(jsonData)
                     */
                    let apiResponse = try JSONDecoder().decode(Response<T>.self, from: responseData)
                    if let decodedValue = apiResponse.products {
                        completionHandler(.success(decodedValue))
                    } else {
                        completionHandler(.failure(APIError.invalidDataError))
                    }
                } catch  {
                    completionHandler(.failure(error))
                }
            }
        }
    }
}
