//
//  ListCoordinator.swift
//  ProductViewer
//
//  Copyright © 2016 Target. All rights reserved.
//

import Foundation
import Tempo

/*
 Coordinator for the product list
 */
class ListCoordinator: TempoCoordinator {
    
    // MARK: Presenters, view controllers, view state.
    
    var presenters = [TempoPresenterType]() {
        didSet {
            updateUI()
        }
    }
    
    fileprivate var viewState: ListViewState {
        didSet {
            updateUI()
        }
    }
    
    let dispatcher = Dispatcher()
    
    let dataService = DataService(dataSource: .network)
    
    lazy var viewController: ListViewController = {
        return ListViewController.viewControllerFor(coordinator: self)
    }()
    
    fileprivate func updateUI() {
        for presenter in presenters {
            presenter.present(viewState)
        }
    }
        
    // MARK: Init
    
    required init() {
        viewState = ListViewState(listItems: [])
        updateState()
        registerListeners()
    }
    
    // MARK: ListCoordinator
    
    fileprivate func registerListeners() {
        /*
        dispatcher.addObserver(ListItemPressed.self) { [weak self] e in
            let alert = UIAlertController(title: "Item selected!", message: "🐶", preferredStyle: .alert)
            alert.addAction( UIAlertAction(title: "OK", style: .cancel, handler: nil) )
            self?.viewController.present(alert, animated: true, completion: nil)
        }
         */
        dispatcher.addObserver(ListItemPressed.self) { [weak self] e in
            let detailCoordinator = DetailCoordinator.init(withListItemViewState: e.productItem)
            self?.viewController.navigationController?.pushViewController(detailCoordinator.viewController, animated: true)
        }
    }
    
    func updateState() {
//        viewState.listItems = (1..<10).map { index in
//            ListItemViewState(title: "Puppies!!!", price: "$9.99", image: UIImage(named: "\(index)"))
//        }
        
//        viewState.listItems = (1..<10).map({ index in
//            ListItemViewState.init(title: "non mollit veniam ex",
//                                   price: "$184.06",
//                                   image: UIImage(named: "PlaceHolder"),
//                                   identifier: 0,
//                                   aisle: "b2",
//                                   description: "minim ad et minim ipsum duis irure pariatur deserunt eu cillum anim ipsum velit tempor eu pariatur sunt mollit tempor ut tempor exercitation occaecat ad et veniam et excepteur velit esse eu et ut ipsum consectetur aliquip do quis voluptate cupidatat eu ut consequat adipisicing occaecat adipisicing proident laborum laboris deserunt in laborum est anim ad non",
//                                   imageURL: "https://picsum.photos/id/0/300/300")
//        })
        
        dataService.fetchData { [weak self] (result: Result<[ListItemViewState]>) in
            guard let self = self else { return }
            switch result {
            case .success(let productsList):
                if productsList.count > 0 {
                    self.viewState.listItems = productsList
                } else {
                    self.dispatcher.triggerEvent(EmptyList())
                }
            case .failure:
                self.dispatcher.triggerEvent(FetchError())
            }
        }
        
    }
}
