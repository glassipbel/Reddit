
//
//  Created by Kevin Belter on 10/31/17.
//  Copyright © 2017 Kevin Belter. All rights reserved.
//

import UIKit

class DownloaderAbstract {
    func get(url: String, onSuccess: @escaping ([String: Any])->(), onFailure: ((_ failure: () throws -> ()) -> Void)? = nil, onFailureGeneral: ((Error)->())? = nil) {
        fatalError("You must implement this method in your class.")
    }
}
