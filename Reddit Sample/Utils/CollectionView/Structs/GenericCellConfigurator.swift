
//
//  Created by Kevin Belter on 1/5/17.
//  Copyright © 2017 KevinBelter. All rights reserved.
//

import UIKit

struct GenericCollectionCellConfigurator: Hashable, Equatable {
    var typeCell: CollectionCellType
    var item: Any
    var section: Int
    var sizingType: SizingType
    var classType: AnyClass
    var diffableIdentifier: String?
    
    var className: String { return String(describing: classType) }
    var hashValue: Int { return className.hash }
    
    public static func ==(lhs: GenericCollectionCellConfigurator, rhs: GenericCollectionCellConfigurator) -> Bool {
        return lhs.classType == rhs.classType
    }

    init(classType: AnyClass, typeCell: CollectionCellType = .cell, item: Any = "", section: Int = 0, sizingType: SizingType, diffableIdentifier: String? = nil) {
        self.classType = classType
        self.item = item
        self.section = section
        self.typeCell = typeCell
        self.sizingType = sizingType
        self.diffableIdentifier = diffableIdentifier
    }
}
