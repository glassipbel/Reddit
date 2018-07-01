
//
//  Created by Kevin Belter on 10/31/17.
//  Copyright © 2017 Kevin Belter. All rights reserved.
//

import Foundation

enum APIErrors: Error {
    case noInternet
    case notParsable(message: String)
    case invalidResponse
    case invalidURL
}
