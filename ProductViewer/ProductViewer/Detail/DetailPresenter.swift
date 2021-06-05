//
//  DetailPresenter.swift
//  ProductViewer
//
//  Created by Banisetty Avinash on 6/1/21.
//  Copyright © 2021 Target. All rights reserved.
//

import Tempo

class DetailPresenter: TempoPresenter {
    
    // MARK: Properties
    let viewController: DetailViewController
    
    // MARK: Init
    
    init(withDetailViewController detailVC:DetailViewController) {
        self.viewController = detailVC
        
        self.viewController.cartButton.backgroundColor = UIColor.targetBullseyeRedColor
        self.viewController.cartButton.setTitleColor(UIColor.targetStarkWhiteColor, for: .normal)
        
        self.viewController.listButton.backgroundColor = UIColor.targetStrokeGrayColor
        self.viewController.listButton.setTitleColor(UIColor.targetJetBlackColor, for: .normal)
    }
    
    // MARK: Functions
    public func present(_ viewState: DetailViewState) {
        viewController.priceTag.text = viewState.price
        viewController.descriptionTextView.text = viewState.description
        
        if let imageURL: String = viewState.imageURLString {
            viewController.image.loadImage(with: imageURL)
        }
    }
}
