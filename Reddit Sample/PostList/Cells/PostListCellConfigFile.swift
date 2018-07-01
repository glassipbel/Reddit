//
//  PostListCellConfigFile.swift
//  Reddit Sample
//
//  Created by Kevin on 7/1/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import Foundation

struct PostListCellConfigFile {
    let postId: String
    
    weak var provider: PostListCellProvider?
    weak var actions: PostListCellActions?
}

protocol PostListCellProvider: class {
    func getPost(withId id: String) -> Post?
}

protocol PostListCellActions: class {
    func tapDismiss(post: Post)
    func tapRead(post: Post)
    func tapPost(post: Post)
}
