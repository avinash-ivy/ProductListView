//
//  DetailCoordinator.swift
//  ProductViewer
//
//  Created by Banisetty Avinash on 5/31/21.
//  Copyright © 2021 Target. All rights reserved.
//

import Tempo

/*
 Coordinator for the product detail
 */
class DetailCoordinator: TempoCoordinator {
    
    // MARK: Presenters, view controllers, view state.
    
    var presenters = [TempoPresenterType]() {
        didSet {
            updateUI()
        }
    }
    
    fileprivate var viewState: DetailViewState {
        didSet {
            updateUI()
        }
    }
    
    fileprivate func updateUI() {
        for presenter in presenters {
            presenter.present(viewState)
        }
    }
    
    let dispatcher = Dispatcher()
    
    lazy var viewController: DetailViewController = {
        return DetailViewController.viewControllerFor(coordinator: self)
    }()
    
    // MARK: Init
    
    required init(withListItemViewState: ListItemViewState) {
        viewState = DetailViewState.init(withListItemViewState: withListItemViewState)
        registerListeners()
    }
    
    // MARK: ListCoordinator
    
    fileprivate func registerListeners() {
        dispatcher.addObserver(AddToCartPressed.self) { [weak self] e in
            let alert = UIAlertController(title: "Item added to cart!", message: "👍", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self?.viewController.present(alert, animated: true, completion: nil)
        }

        dispatcher.addObserver(AddToListPressed.self) { [weak self] e in
            let alert = UIAlertController(title: "Item added to list!", message: "👌", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self?.viewController.present(alert, animated: true, completion: nil)
        }
    }
    
}
