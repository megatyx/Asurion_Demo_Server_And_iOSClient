//
//  UIImageViewExtensions.swift
//  Asurion-iOS-Demo
//
//  Created by Tyler Wells on 8/24/20.
//  Copyright © 2020 Tyler Wells. All rights reserved.
//

import UIKit
import Foundation


let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func loadImageUsingCache(withUrl url : URL) {
        self.image = nil

        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString)  {
            self.image = cachedImage
            return
        }

        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.center

        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    self.image = image
                    activityIndicator.removeFromSuperview()
                }
            }
        }).resume()
    }
}
