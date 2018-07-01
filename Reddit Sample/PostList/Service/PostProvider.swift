//
//  PostProvider.swift
//  Reddit Sample
//
//  Created by Kevin on 7/1/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import Foundation

final class PostProvider {
    var cachedPosts: [Post]
    
    init(downloader: DownloaderAbstract, postMapper: PostMapper) {
        self.downloader = downloader
        self.cachedPosts = []
        self.postMapper = postMapper
        self.shouldKeepRequestion = true
    }
    
    func getDrilldownPosts(completion: @escaping ([Post]) -> ()) {
        downloader.get(
            url: getURL(),
            onSuccess: { [unowned self] redditResponseJSON in
                let posts = self.postMapper.mapPosts(dict: redditResponseJSON)
                self.afterKey = self.postMapper.getAfterKey(dict: redditResponseJSON)
                self.shouldKeepRequestion = self.afterKey != nil
                self.cachedPosts.append(contentsOf: posts)
                DispatchQueue.main.async {
                     completion(posts)
                }
            }
        )
    }
    
    func clean() {
        afterKey = nil
        cachedPosts = []
        shouldKeepRequestion = true
        Post.cleanPostsState()
    }
    
    private func getURL() -> String {
        guard let after = afterKey else {
            return mainURL
        }
        
        return mainURL + "&after=\(after)"
    }
    
    private let mainURL = "https://www.reddit.com/r/all/top/.json?t=all&limit=10"
    private var downloader: DownloaderAbstract
    private var postMapper: PostMapper
    private var afterKey: String?
    private var shouldKeepRequestion: Bool
}
