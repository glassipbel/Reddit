
//
//  Created by Kevin Belter on 1/14/17.
//  Copyright © 2017 Kevin Belter. All rights reserved.
//

import UIKit

enum SizingType {
    case specificSize(CGSize)
    case specificHeight(CGFloat)
    case cell(GenericCollectionCellSelfSizingProtocol)
    case header(GenericCollectionHeaderSelfSizingProtocol)
    case footer(GenericCollectionFooterSelfSizingProtocol)
}
