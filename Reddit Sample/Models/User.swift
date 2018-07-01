//
//  User.swift
//  Reddit Sample
//
//  Created by Kevin on 7/1/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import Foundation

final class User {
    let username: String
    
    init(username: String) {
        self.username = username
    }
    
    convenience init?(dict: [String: Any]) {
        guard let username = dict["author"] as? String else { return nil }
        self.init(username: username)
    }
}
