//
//  UIImageView+Extensions.swift
//  ProductViewer
//
//  Created by Banisetty Avinash on 6/3/21.
//  Copyright © 2021 Target. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
        
    func loadImage(with urlString: String, placeholderImageName: String? = nil) {
                
        if let validUrl = NSURL(string: urlString),let cacheImage = ImageCache.cache.image(url: validUrl) {
            self.image = cacheImage
            return
        }
                
        let placeholderImage: UIImage?

        if let placeholderImageName: String = placeholderImageName, let image: UIImage = UIImage(named: placeholderImageName) {
            placeholderImage = image
        }
        else {
            placeholderImage = UIImage.clearImage
        }
        
//        self.image = placeholderImage

        let loadingView: UIActivityIndicatorView = UIActivityIndicatorView()

        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.startAnimating()

        addAndPinSubview(loadingView)

        if let url: NSURL = NSURL(string: urlString) {
            ImageCache.cache.load(url: url) { (image) in
                for subview in self.subviews where subview is UIActivityIndicatorView {
                    subview.removeFromSuperview()
                }
                if let image: UIImage = image {
                    self.image = image
                }
            }
        }
    }
}
