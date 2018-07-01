//
//  PostDetailViewController.swift
//  Reddit Sample
//
//  Created by Kevin on 7/1/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

final class PostDetailViewController: UIViewController {
    
}

extension PostDetailViewController {
    static func newInstance() -> PostDetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        return vc
    }
}
