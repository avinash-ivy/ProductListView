//
//  ListModel.swift
//  ProductViewer
//
//  Created by Banisetty Avinash on 6/5/21.
//  Copyright © 2021 Target. All rights reserved.
//

import Foundation

struct ListModel: Decodable {
    let title: String
    let price: String
    // Adding additional details from API response added by Avinash
    let identifier: Int
    let aisle: String
    let description: String
    let imageURL: String?
    
    private enum RootKeys: String, CodingKey {
        case identifier = "id"
        case imageURL = "image_url"
        case regular_price
        case title
        case aisle
        case description
        case price
    }
    
    private enum PriceKeys: String, CodingKey {
        case display_string
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        identifier = try container.decode(Int.self, forKey: .identifier)
        imageURL = try container.decode(String.self, forKey: .imageURL)
        title = try container.decode(String.self, forKey: .title)
        aisle = try container.decode(String.self, forKey: .aisle)
        description = try container.decode(String.self, forKey: .description)
        let priceContainer = try container.nestedContainer(keyedBy: PriceKeys.self, forKey: .regular_price)
        price = try priceContainer.decode(String.self, forKey: .display_string)
    }
}
