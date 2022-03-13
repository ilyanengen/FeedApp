//
//  FeedViewController.swift
//  FeedApp
//
//  Created by Илья Билтуев on 13.03.2022.
//

import UIKit

class FeedViewController: UIViewController {
    
    enum Section {
        case main
    }

    weak var delegate: FeedViewControllerDelegate?
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let feedService = ServiceLayer.shared.feedService
    
    private lazy var dataSource = setupDataSource()
    
    private let code: Code
    
    private var feedItems: [FeedItem] = []
    
    init(code: Code) {
        self.code = code
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialDataSource()
        loadFeedItems()
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.tableFooterView = UIView()
    }
    
    private func setupDataSource() -> UITableViewDiffableDataSource<Section, FeedItem> {
        tableView.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: FeedCell.reuseIdentifier)
        let dataSource = UITableViewDiffableDataSource<Section, FeedItem>(tableView: tableView) {
            tableView, indexPath, feedItem -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: FeedCell.reuseIdentifier,
                for: indexPath) as? FeedCell
            else {
                return nil
            }
            cell.configure(feedItem: feedItem)
            return cell
        }
        return dataSource
    }
    
    private func setInitialDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, FeedItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems([])
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func setItemsToDataSource(_ feedItems: [FeedItem]) {
        var currentSnapshot = dataSource.snapshot()
        currentSnapshot.deleteAllItems()
        currentSnapshot.appendSections([.main])
        currentSnapshot.appendItems(feedItems)
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
    
    private func appendItemsToDataSource(_ feedItems: [FeedItem]) {
        var currentSnapshot = dataSource.snapshot()
        currentSnapshot.appendItems(feedItems)
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
    
    private func loadFeedItems() {
        feedService.fetchFeedItems(code: code, offset: 0) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let feedItems):
                    self.feedItems.append(contentsOf: feedItems)
                    self.appendItemsToDataSource(feedItems)
                }
            }
        }
    }
}

protocol FeedViewControllerDelegate: AnyObject {
    func feedViewControllerDidLogOut(_ viewController: FeedViewController)
}
