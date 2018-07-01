//
//  PostListController.swift
//  Reddit Sample
//
//  Created by Kevin on 7/1/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import Foundation

final class PostListController {
    init(downloader: DownloaderAbstract, postMapper: PostMapper) {
        self.provider = PostProvider(downloader: downloader, postMapper: postMapper)
    }
    
    func getDrilldownPostCells(completion: @escaping ([GenericCollectionCellConfigurator]) -> ()) {
        provider.getDrilldownPosts { posts in
            DispatchQueue.main.async { [unowned self] in
                completion(posts.map { self.getPostCell(post: $0) })
            }
        }
    }
    
    private var provider: PostProvider
}

extension PostListController {
    private func getPostCell(post: Post) -> GenericCollectionCellConfigurator {
        //TODO KEV: Change this.
        return GenericCollectionCellConfigurator(classType: PostListController.self, sizingType: SizingType.specificHeight(0))
    }
}

extension PostListController {
    func getPost(withId id: String) -> Post? {
        return provider.cachedPosts.first { $0.id == id }
    }
}
