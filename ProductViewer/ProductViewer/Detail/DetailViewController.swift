//
//  DetailViewController.swift
//  ProductViewer
//
//  Created by Banisetty Avinash on 5/31/21.
//  Copyright © 2021 Target. All rights reserved.
//

import UIKit
import Tempo

class DetailViewController: UIViewController {
        
    // MARK: IBOutlets
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var priceTag: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    
    // MARK: Properties
    
    fileprivate var coordinator: TempoCoordinator!
    
    // MARK: Class methods
    
    // Kind of Initializer
    class func viewControllerFor(coordinator: TempoCoordinator) -> DetailViewController {
        let viewController = DetailViewController.init(nibName: "DetailView", bundle: nil)
        viewController.coordinator = coordinator
        return viewController
    }
    
    // MARK: View methods

    override func viewDidLoad() {
        super.viewDidLoad()

        coordinator.presenters = [DetailPresenter.init(withDetailViewController: self)]
        self.navigationController?.navigationBar.tintColor = UIColor.targetBullseyeRedColor
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func addToCartAction(_ sender: Any) {
        coordinator.dispatcher.triggerEvent(AddToCartPressed())
    }
    
    @IBAction func addToListAction(_ sender: Any) {
        coordinator.dispatcher.triggerEvent(AddToListPressed())
    }
}
