//
//  ButtonExtensions.swift
//  Reddit Sample
//
//  Created by Kevin on 7/1/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

extension UIButton {
    convenience init(font: UIFont, titleColor: UIColor, title: String, backgroundColor: UIColor) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitle(title, for: UIControlState())
        self.setTitleColor(titleColor, for: UIControlState())
        self.backgroundColor = backgroundColor
        self.titleLabel!.font = font
    }
}
