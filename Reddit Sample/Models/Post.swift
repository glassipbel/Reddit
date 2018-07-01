//
//  Post.swift
//  Reddit Sample
//
//  Created by Kevin on 7/1/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import Foundation

final class Post {
    let id: String
    let author: User
    let creationTime: Date
    let thumbnailURL: URL?
    let title: String
    let commentsAmount: Int
    
    init(id: String, author: User, creationTime: Date, thumbnailURL: URL?, title: String, commentsAmount: Int) {
        self.id = id
        self.author = author
        self.creationTime = creationTime
        self.thumbnailURL = thumbnailURL
        self.title = title
        self.commentsAmount = commentsAmount
    }
    
    convenience init?(dict: [String: Any]) {
        guard let id = dict["id"] as? String else { return nil }
        guard let author = User(dict: dict) else { return nil }
        guard let creationTimeStamp = dict["created_utc"] as? Double else { return nil }
        let creationTime = Date(timeIntervalSince1970: creationTimeStamp)
        
        var thumbnailURL: URL? = nil
        if let thumbnailURLString = dict["thumbnail"] as? String {
            thumbnailURL = URL(string: thumbnailURLString)
        }
        
        guard let title = dict["title"] as? String else { return nil }
        guard let commentsAmount = dict["num_comments"] as? Int else { return nil }
        
        self.init(id: id, author: author, creationTime: creationTime, thumbnailURL: thumbnailURL, title: title, commentsAmount: commentsAmount)
    }
    
    private let readPostsKey = "read_posts"
    private let dismissedPostsKey = "dismissed_posts"
}

extension Post {
    var creationTimePrintable: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: self.creationTime)
    }
    
    var read: Bool {
        let defaults = UserDefaults.standard
        if let readPosts = defaults.value(forKey: readPostsKey) as? [String] {
            return readPosts.contains(id)
        }
        return false
    }
    
    func markAsRead() {
        let defaults = UserDefaults.standard
        if var readPosts = defaults.value(forKey: readPostsKey) as? [String] {
            if readPosts.contains(id) { return }
            readPosts.append(id)
            defaults.set(readPosts, forKey: readPostsKey)
        } else {
            defaults.set([id], forKey: readPostsKey)
        }
        defaults.synchronize()
    }
    
    var dismissed: Bool {
        let defaults = UserDefaults.standard
        if let dismissedPosts = defaults.value(forKey: dismissedPostsKey) as? [String] {
            return dismissedPosts.contains(id)
        }
        return false
    }
    
    func markAsDismissed() {
        let defaults = UserDefaults.standard
        if var dismissedPosts = defaults.value(forKey: dismissedPostsKey) as? [String] {
            if dismissedPosts.contains(id) { return }
            dismissedPosts.append(id)
            defaults.set(dismissedPosts, forKey: dismissedPostsKey)
        } else {
            defaults.set([id], forKey: dismissedPostsKey)
        }
        defaults.synchronize()
    }
}
