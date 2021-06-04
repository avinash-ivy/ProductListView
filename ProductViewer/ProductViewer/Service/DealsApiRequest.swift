//
//  DealsApiRequest.swift
//  ProductViewer
//
//  Created by Banisetty Avinash on 6/1/21.
//  Copyright © 2021 Target. All rights reserved.
//

// https://api.target.com/mobile_case_study_deals/v1/deals
// https://picsum.photos/id/0/300/300

import Foundation

struct DealsApiRequest: APIRequestType {
    var baseURL: URL {
        // TODO: Uncomment and remove duplicates - Sample API used
        let urlString = "https://api.target.com/mobile_case_study_deals"
//        let urlString = "https://target-deals.herokuapp.com"
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL for DealsApiRequest")
        }
        return url
    }
    
    var apiPath: String {
        return "/v1/deals"
//        return "/api/deals"
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
