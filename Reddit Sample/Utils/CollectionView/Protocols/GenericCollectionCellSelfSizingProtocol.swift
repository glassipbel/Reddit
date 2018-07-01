
//
//  Created by Kevin Belter on 1/14/17.
//  Copyright © 2017 Kevin Belter. All rights reserved.
//

import UIKit

protocol GenericCollectionCellSelfSizingProtocol {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath, with item: Any) -> CGSize
}
