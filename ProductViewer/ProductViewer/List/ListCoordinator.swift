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
        dispatcher.addObserver(ListItemPressed.self) { [weak self] e in
            let detailCoordinator = DetailCoordinator.init(withListItemViewState: e.productItem)
            self?.viewController.navigationController?.pushViewController(detailCoordinator.viewController, animated: true)
        }
    }
    
    func updateState() {
        dataService.fetchData { [weak self] (result: Result<[ListModel]>) in
            guard let self = self else { return }
            switch result {
            case .success(let productsList):
                if productsList.count > 0 {
                    self.viewState.listItems = self.listViewStateItems(fromListModels: productsList)
                } else {
                    self.dispatcher.triggerEvent(EmptyList())
                }
            case .failure:
                self.dispatcher.triggerEvent(FetchError())
            }
        }
    }
    
    func listViewStateItems(fromListModels productModels: [ListModel]) -> [ListItemViewState] {
        var listItemViewStates = [ListItemViewState]()
        productModels.forEach { listModel in
            let viewStateItem = ListItemViewState(title: listModel.title,
                                                  price: listModel.price,
                                                  aisle: listModel.aisle,
                                                  imageURL: listModel.imageURL,
                                                  description: listModel.description)
            listItemViewStates.append(viewStateItem)
        }
        return listItemViewStates
    }
}
