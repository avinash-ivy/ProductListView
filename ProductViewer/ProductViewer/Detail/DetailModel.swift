//
//  DetailModel.swift
//  ProductViewer
//
//  Created by Banisetty Avinash on 5/31/21.
//  Copyright © 2021 Target. All rights reserved.
//

import Foundation

// This model is not required as ListModel is having these attributes already. So not using
struct DetailModel {
    let id: Int
    let title: String
    let aisle: String
    let description: String
    let imageURL: String
    let amountInCents: Int
    let currencySymbol: String
    let displayString: String
}
