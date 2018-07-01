//
//  PostListCell.swift
//  Reddit Sample
//
//  Created by Kevin on 7/1/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

final class PostListCell: UICollectionViewCell {
    // MARK: - Visual Elements
    // If you are asking why i don't use a xib file or storyboard, is because this way you have more control and also in a large project you can work without the merge conflicts that a xib file or even storyboard provides. I also would like to not use storyboard for the main app, but the test requiere me to use them so i don't have remedy in that matter.
    
    private let readView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 5.0
        return view
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel(font: UIFont.boldSystemFont(ofSize: 14.0), textColor: .white, textAlignment: .left)
        return label
    }()
    
    private let createdTimeLabel: UILabel = {
        let label = UILabel(font: UIFont.systemFont(ofSize: 12.0), textColor: UIColor.white.withAlphaComponent(0.7), textAlignment: .left)
        return label
    }()
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView(target: nil, action: nil)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel(font: UIFont.systemFont(ofSize: 12.0), textColor: .white, textAlignment: .left)
        label.numberOfLines = 0
        return label
    }()
    
    private let rightArrowImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "right-arrow"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var dismissImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "dismiss_icon"), target: self, action: #selector(tapDismiss))
        return imageView
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton(font: UIFont.boldSystemFont(ofSize: 12.0), titleColor: .white, title: "Dismiss Post", backgroundColor: .clear)
        button.addTarget(self, action: #selector(tapDismiss), for: .touchUpInside)
        return button
    }()
    
    private let commentsLabel: UILabel = {
        let label = UILabel(font: UIFont.systemFont(ofSize: 12.0), textColor: UIColor.orange.withAlphaComponent(0.5), textAlignment: .left)
        return label
    }()
    
    private let bottomSeparatorView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    // ---
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
        setupConstraints()
    }
    
    @objc func tapDismiss() {
        guard let id = configFile?.postId, let post = configFile?.provider?.getPost(withId: id) else { return }
        configFile?.actions?.tapDismiss(post: post)
    }
    
    private var configFile: PostListCellConfigFile?
}

extension PostListCell: GenericCollectionCellProtocol, GenericCollectionCellSelfSizingProtocol {
    func collectionView(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, with item: Any) {
        guard let configFile = item as? PostListCellConfigFile else { return }
        guard let post = configFile.provider?.getPost(withId: configFile.postId) else { return }
        
        self.configFile = configFile
        
        readView.isHidden = post.read
        authorLabel.text = post.author.username
        createdTimeLabel.text = post.creationTimePrintable
        if let url = post.thumbnailURL {
            thumbnailImageView.imageAsync(url: url)
        } else {
            thumbnailImageView.image = #imageLiteral(resourceName: "placeholder")
        }
        titleLabel.text = post.title
        commentsLabel.text = "\(post.commentsAmount) comments"
    }
    
//    func collectionView(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let id = configFile?.postId, let post = configFile?.provider?.getPost(withId: id) else { return }
//        configFile?.actions?.tapPost(post: post)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath, with item: Any) -> CGSize {
        self.collectionView(collectionView: collectionView, cellForItemAt: indexPath, with: item)
        let suggestedSize = selfSizing(desiredWidth: collectionView.bounds.width)
        return CGSize(width: suggestedSize.width, height: suggestedSize.height)
    }
}

extension PostListCell {
    private func setupViews() {
        contentView.addSubview(readView)
        contentView.addSubview(authorLabel)
        contentView.addSubview(createdTimeLabel)
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(rightArrowImageView)
        contentView.addSubview(commentsLabel)
        contentView.addSubview(bottomSeparatorView)
        contentView.addSubview(dismissImageView)
        contentView.addSubview(dismissButton)
    }
    
    private func setupConstraints() {
        readView.widthAnchor.constraint(equalToConstant: 10.0).isActive = true
        readView.heightAnchor.constraint(equalToConstant: 10.0).isActive = true
        readView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14.0).isActive = true
        readView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 14.0).isActive = true
        
        authorLabel.leftAnchor.constraint(equalTo: readView.rightAnchor, constant: 10.0).isActive = true
        authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14.0).isActive = true
        
        createdTimeLabel.leftAnchor.constraint(equalTo: authorLabel.rightAnchor, constant: 10.0).isActive = true
        createdTimeLabel.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -14.0).isActive = true
        createdTimeLabel.centerYAnchor.constraint(equalTo: authorLabel.centerYAnchor).isActive = true
        
        thumbnailImageView.topAnchor.constraint(greaterThanOrEqualTo: authorLabel.bottomAnchor, constant: 14.0).isActive = true
        thumbnailImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        thumbnailImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 14.0).isActive = true
        thumbnailImageView.widthAnchor.constraint(equalToConstant: 90.0).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalToConstant: 90.0).isActive = true
        thumbnailImageView.bottomAnchor.constraint(lessThanOrEqualTo: dismissImageView.topAnchor, constant: -14.0).isActive = true
        
        titleLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .vertical)
        titleLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 14.0).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: dismissImageView.topAnchor, constant: -4.0).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: thumbnailImageView.rightAnchor, constant: 14.0).isActive = true
        
        rightArrowImageView.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
        rightArrowImageView.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
        rightArrowImageView.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 14.0).isActive = true
        rightArrowImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -14.0).isActive = true
        rightArrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        dismissImageView.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
        dismissImageView.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
        dismissImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 14.0).isActive = true
        dismissImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14.0).isActive = true
        
        dismissButton.centerYAnchor.constraint(equalTo: dismissImageView.centerYAnchor).isActive = true
        dismissButton.leftAnchor.constraint(equalTo: dismissImageView.rightAnchor, constant: 8.0).isActive = true
        
        commentsLabel.rightAnchor.constraint(equalTo: rightArrowImageView.rightAnchor, constant: -14.0).isActive = true
        commentsLabel.centerYAnchor.constraint(equalTo: dismissImageView.centerYAnchor).isActive = true
        
        bottomSeparatorView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        bottomSeparatorView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 14.0).isActive = true
        bottomSeparatorView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -14.0).isActive = true
        bottomSeparatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
