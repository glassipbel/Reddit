//
//  ImageViewExtensions.swift
//  Reddit Sample
//
//  Created by Kevin on 7/1/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

extension UIImageView {
    convenience init(image: UIImage? = nil, target: Any?, action: Selector?) {
        self.init(image: image)
        
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        
        self.addGestureRecognizer(tapGesture)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFit
        self.isUserInteractionEnabled = true
    }
    
    public func imageAsync(url: URL) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }).resume()
    }
}
