//
//  DetailViewState.swift
//  ProductViewer
//
//  Created by Banisetty Avinash on 5/31/21.
//  Copyright © 2021 Target. All rights reserved.
//

import Tempo

struct DetailButtonState {
    let buttonColor: UIColor
    let titleColor: UIColor
}

struct DetailViewState: TempoViewState {
    var imageURLString: String?
    let price: String
    let description: String
    // Remove once not needed
    var image: UIImage?
    
    // You can configure button state also here
        
    init(imageURL urlString: String, price priceString: String, description text: String) {
        self.imageURLString = urlString
        self.price = priceString
        self.description = text
    }
    
    init(price priceString: String, description text: String) {
        self.price = priceString
        self.description = text
    }
    
    
    init(withListItemViewState viewState: ListItemViewState) {
        self.init(price: viewState.price, description: viewState.description)
        if let imageURLString = viewState.imageURL {
            self.imageURLString = imageURLString
        }
    }
}
