//
//  PostListViewController.swift
//  Reddit Sample
//
//  Created by Kevin on 7/1/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

final class PostListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshList), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.orange
        return refreshControl
    }()
    
    override func viewDidLoad() {
        setupController()
        collectionView.addSubview(refreshControl)
        
        controller.getDrilldownPostCells { [weak self] configFiles in
            self?.setupDatasourceAndDelegate(configFiles: configFiles)
        }
    }
    
    @IBAction func tapDismissAll() {
        controller.markAllPostsAsDismissed()
        datasource?.deleteAllRowsAt(section: 0)
    }
    
    @objc func refreshList() {
        controller.refresh { [weak self] configFiles in
            self?.datasource?.deleteEverything(andInsert: configFiles) {
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    private var datasource: GenericCollectionViewDataSource?
    private var delegate: GenericCollectionViewDelegate?
    private var controller: PostListController!
}

extension PostListViewController {
    private func setupController() {
        controller = PostListController(
            postCellActions: self,
            downloader: URLSessionDownloader(),
            postMapper: PostManualMapper()
        )
    }
    
    private func setupDatasourceAndDelegate(configFiles: [GenericCollectionCellConfigurator]) {
        datasource = GenericCollectionViewDataSource(collectionView: collectionView, configFiles: configFiles)
        delegate = GenericCollectionViewDelegate(dataSource: datasource!, actions: self)
    }
    
    private func getIndexPath(ofPost post: Post) -> IndexPath? {
        return datasource?.getIndexPath {
            guard let item = $0.item as? PostListCellConfigFile else { return false }
            return item.postId == post.id
        }
    }
}

extension PostListViewController: PostListCellActions {
    func tapDismiss(post: Post) {
        post.markAsDismissed()
        datasource?.deleteRow(by: {
            guard let item = $0.item as? PostListCellConfigFile else { return false }
            return item.postId == post.id
        })
    }
    
    func tapPost(post: Post) {
        post.markAsRead()
        if let indexPath = getIndexPath(ofPost: post) {
           datasource?.reloadAt(indexPath: indexPath)
        }
        
        showDetailViewController(PostDetailViewController.newInstance(post: post), sender: self)
    }
}

extension PostListViewController: GenericCollectionActions {
    func reachLastCellInCollection() {
        controller.getDrilldownPostCells { [weak self] configFiles in
            self?.datasource?.insertRows(configFiles: configFiles)
        }
    }
}
