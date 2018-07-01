//
//  CollectionViewCellExtensions.swift
//  Reddit Sample
//
//  Created by Kevin on 7/1/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    func selfSizing(desiredWidth: CGFloat) -> CGSize {
        let size = contentView.systemLayoutSizeFitting(CGSize(width: desiredWidth, height: UILayoutFittingCompressedSize.height), withHorizontalFittingPriority: UILayoutPriority(rawValue: 1000.0), verticalFittingPriority: UILayoutPriority(rawValue: 250.0))
        return CGSize(width: desiredWidth, height: ceil(size.height))
    }
}
