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
        configureView()
        configureRightItem()
    }
    
    @IBAction func tapImage(_ sender: UITapGestureRecognizer) {
        guard let url = post?.thumbnailURL else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func tapSaveImage() {
        guard let image = thumbnailImageView.image else { return }
        
        let alert = UIAlertController(title: "Save Image", message: "Do you want to save the image in your library?", preferredStyle: UIAlertControllerStyle.alert)
        let actionOk = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        })
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actionOk)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func configureView() {
        authorLabel.text = post?.author.username ?? ""
        if let url = post?.thumbnailURL {
            thumbnailImageView.imageAsync(url: url)
        } else {
            thumbnailImageView.image = nil
        }
        titleLabel.text = post?.title ?? ""
    }
    
    private func configureRightItem() {
        let saveItem = UIBarButtonItem(title: "Save image", style: .plain, target: self, action: #selector(tapSaveImage))
        navigationItem.rightBarButtonItem = saveItem
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
