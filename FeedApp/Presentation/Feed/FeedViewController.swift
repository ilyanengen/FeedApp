//
//  FeedViewController.swift
//  FeedApp
//
//  Created by Илья Билтуев on 13.03.2022.
//

import UIKit

class FeedViewController: UIViewController {

    weak var delegate: FeedViewControllerDelegate?
    
    private let feedService = ServiceLayer.shared.feedService
    
    private let code: Code
    
    init(code: Code) {
        self.code = code
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFeedItems()
    }
    
    private func loadFeedItems() {
        feedService.fetchFeedItems(code: code, offset: 0) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let feedItems):
                    print(feedItems)
                }
            }
        }
    }
}

protocol FeedViewControllerDelegate: AnyObject {
    func feedViewControllerDidLogOut(_ viewController: FeedViewController)
}
