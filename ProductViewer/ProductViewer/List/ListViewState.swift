//
//  ListViewState.swift
//  ProductViewer
//
//  Copyright © 2016 Target. All rights reserved.
//

import Tempo

/// List view state
struct ListViewState: TempoViewState, TempoSectionedViewState {
    var listItems: [TempoViewStateItem]
    
    var sections: [TempoViewStateItem] {
        return listItems
    }
}

/// View state for each list item.
struct ListItemViewState: TempoViewStateItem, Equatable, Decodable {
    let title: String
    let price: String
    
    //Adding additional details from API response added by Avinash
    let identifier: Int
    let aisle: String
    let description: String
    let imageURL: String?
        
    private enum RootKeys: String, CodingKey {
// TODO: Uncomment and remove duplicates - Sample API used
        case identifier = "id"
//        case identifier = "_id"
        case imageURL = "image_url"
//        case imageURL = "image"
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
//        price = try container.decode(String.self, forKey: .price)
        // TODO: Uncomment and remove duplicates - Sample API used
        let priceContainer = try container.nestedContainer(keyedBy: PriceKeys.self, forKey: .regular_price)
        price = try priceContainer.decode(String.self, forKey: .display_string)
    }
}

func ==(lhs: ListItemViewState, rhs: ListItemViewState) -> Bool {
    return lhs.title == rhs.title
        && lhs.price == rhs.price
}
