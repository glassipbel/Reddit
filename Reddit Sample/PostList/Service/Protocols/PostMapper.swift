//
//  PostMapper.swift
//  Reddit Sample
//
//  Created by Kevin on 7/1/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import Foundation

protocol PostMapper: class {
    func mapPosts(dict: [String: Any]) -> [Post]
    func getAfterKey(dict: [String: Any]) -> String?
}
