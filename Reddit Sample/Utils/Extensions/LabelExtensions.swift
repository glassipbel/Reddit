//
//  LabelExtensions.swift
//  Reddit Sample
//
//  Created by Kevin on 7/1/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(font: UIFont, textColor: UIColor, textAlignment: NSTextAlignment) {
        self.init(frame: CGRect.zero)
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
