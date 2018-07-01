
//
//  Created by Kevin Belter on 1/14/17.
//  Copyright © 2017 Kevin Belter. All rights reserved.
//

import UIKit

protocol GenericCollectionFooterSelfSizingProtocol {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int, with item: Any) -> CGSize
}
