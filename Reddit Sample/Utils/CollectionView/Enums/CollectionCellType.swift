
//
//  Created by Kevin Belter on 1/5/17.
//  Copyright © 2017 KevinBelter. All rights reserved.
//

import UIKit

enum CollectionCellType {
    case cell
    case header
    case footer
    
    static func getCollectionCellTypeBySupplementaryKind(kind: String) -> CollectionCellType? {
        switch kind {
            case UICollectionElementKindSectionHeader: return .header
            case UICollectionElementKindSectionFooter: return .footer
            default: return nil
        }
    }
}
