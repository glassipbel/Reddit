//
//  PostDetailViewController.swift
//  Reddit Sample
//
//  Created by Kevin on 7/1/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

final class PostDetailViewController: UIViewController {
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        authorLabel.text = post?.author.username ?? ""
        if let url = post?.thumbnailURL {
            thumbnailImageView.imageAsync(url: url)
        } else {
            thumbnailImageView.image = nil
            thumbnailImageView.backgroundColor = .lightGray
        }
        titleLabel.text = post?.title ?? ""
    }
    
    @IBAction func tapImage(_ sender: UITapGestureRecognizer) {
        guard let url = post?.thumbnailURL else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private weak var post: Post?
}

extension PostDetailViewController {
    static func newInstance(post: Post) -> PostDetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        vc.post = post
        return vc
    }
}
