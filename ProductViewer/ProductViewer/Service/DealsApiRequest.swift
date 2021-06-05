//
//  DealsApiRequest.swift
//  ProductViewer
//
//  Created by Banisetty Avinash on 6/1/21.
//  Copyright © 2021 Target. All rights reserved.
//

import Foundation

struct DealsApiRequest: APIRequestType {
    var baseURL: URL {
        let urlString = "https://api.target.com/mobile_case_study_deals"
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL for DealsApiRequest")
        }
        return url
    }
    
    var apiPath: String {
        return "/v1/deals"
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var makeParams: HTTPParameterUtil {
        return .defaultParameter
    }
    
    var headers: Headers? {
        return nil
    }
}
