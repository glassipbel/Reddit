//
//  PostListController.swift
//  Reddit Sample
//
//  Created by Kevin on 7/1/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import Foundation

final class PostListController {
    init(postCellActions: PostListCellActions?, downloader: DownloaderAbstract, postMapper: PostMapper) {
        self.provider = PostProvider(downloader: downloader, postMapper: postMapper)
        self.postCellActions = postCellActions
    }
    
    func getDrilldownPostCells(completion: @escaping ([GenericCollectionCellConfigurator]) -> ()) {
        provider.getDrilldownPosts { posts in
            DispatchQueue.main.async { [unowned self] in
                completion(posts.map { self.getPostCell(post: $0) })
            }
        }
    }
    
    func markAllPostsAsDismissed() {
        provider.cachedPosts.forEach {
            $0.markAsDismissed()
        }
    }
    
    func refresh(completion: @escaping ([GenericCollectionCellConfigurator]) -> ()) {
        provider.clean()
        getDrilldownPostCells(completion: completion)
    }
    
    private weak var postCellActions: PostListCellActions?
    private var cellSizing: PostListCell = PostListCell(frame: .zero)
    private var provider: PostProvider
}

// MARK: - Cell Builder.
extension PostListController {
    private func getPostCell(post: Post) -> GenericCollectionCellConfigurator {
        let item = PostListCellConfigFile(postId: post.id, provider: self, actions: postCellActions)
        
        return GenericCollectionCellConfigurator(
            classType: PostListCell.self,
            item: item,
            sizingType: SizingType.cell(cellSizing),
            diffableIdentifier: post.id
        )
    }
}

// MARK: - Post Provider
extension PostListController: PostListCellProvider {
    func getPost(withId id: String) -> Post? {
        return provider.cachedPosts.first { $0.id == id }
    }
}
