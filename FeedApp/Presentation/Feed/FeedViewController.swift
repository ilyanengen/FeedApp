//
//  FeedViewController.swift
//  FeedApp
//
//  Created by Илья Билтуев on 13.03.2022.
//

import UIKit

class FeedViewController: UIViewController {

    weak var delegate: FeedViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

protocol FeedViewControllerDelegate: AnyObject {
    func feedViewControllerDidLogOut(_ viewController: FeedViewController)
}
