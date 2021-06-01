//
//  ListEvents.swift
//  ProductViewer
//
//  Copyright © 2016 Target. All rights reserved.
//

import Tempo

struct ListItemPressed: EventType {
    //Added
    let productItem: ListItemViewState
}

// Added
struct FetchError: EventType {}
struct EmptyList: EventType {}

