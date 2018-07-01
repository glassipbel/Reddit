//
//  PostManualMapper.swift
//  Reddit Sample
//
//  Created by Kevin on 7/1/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import Foundation

final class PostManualMapper: PostMapper {
    func getAfterKey(dict: [String : Any]) -> String? {
        guard let dataDict = dict["data"] as? [String: Any] else { return nil }
        return dataDict["after"] as? String
    }
    
    func mapPosts(dict: [String : Any]) -> [Post] {
        guard let dataDict = dict["data"] as? [String: Any] else { return [] }
        guard let childrenDictArray = dataDict["children"] as? [[String: Any]] else { return [] }
        return childrenDictArray.compactMap {
            guard let postDict = $0["data"] as? [String: Any] else { return nil }
            return Post(dict: postDict)
        }
    }
}
