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
    
    private lazy var dataSource = setupDataSource()
    private lazy var footerLoadingIndicator = UIActivityIndicatorView()
    private lazy var topRefreshControl = UIRefreshControl()
    
    private let feedService = ServiceLayer.shared.feedService
    private let code: Code
    private var feedItems: [FeedItem] = []
    private var isLoading: Bool = false
    
    init(code: Code) {
        self.code = code
        super.init(nibName: nil, bundle: nil)
        self.title = "Feed"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureTableView()
        loadFeedItems()
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            style: .plain,
            target: self,
            action: #selector(logoutButtonDidTap)
        )
    }
    
    private func configureTableView() {
        setInitialDataSourceSnapshot()
        footerLoadingIndicator.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
        tableView.tableFooterView = footerLoadingIndicator
        topRefreshControl.addTarget(self, action: #selector(topRefreshControlDidDrag), for: .valueChanged)
        tableView.refreshControl = topRefreshControl
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

    private func setInitialDataSourceSnapshot() {
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
        currentSnapshot.reloadSections([.main])
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
    
    private func appendItemsToDataSource(_ feedItems: [FeedItem]) {
        var currentSnapshot = dataSource.snapshot()
        currentSnapshot.appendItems(feedItems)
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
    
    private func loadFeedItems() {
        isLoading = true
        feedService.fetchFeedItems(code: code, offset: 0) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            DispatchQueue.main.async {
                self.topRefreshControl.endRefreshing()
                switch result {
                case .failure(let error):
                    self.showErrorAlert(error: error)
                case .success(let feedItems):
                    self.feedItems = feedItems
                    self.setItemsToDataSource(feedItems)
                }
            }
        }
    }
    
    private func loadMore() {
        isLoading = true
        footerLoadingIndicator.startAnimating()
        feedService.fetchFeedItems(code: code, offset: feedItems.count) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            DispatchQueue.main.async {
                self.footerLoadingIndicator.stopAnimating()
                switch result {
                case .failure(let error):
                    self.showErrorAlert(error: error)
                case .success(let feedItems):
                    self.feedItems.append(contentsOf: feedItems)
                    self.appendItemsToDataSource(feedItems)
                }
            }
        }
    }
    
    @objc private func topRefreshControlDidDrag() {
        loadFeedItems()
    }
    
    @objc private func logoutButtonDidTap() {
        delegate?.feedViewControllerDidLogOut(self)
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let selectedFeedItem = dataSource.itemIdentifier(for: indexPath) else { return }
        let mapVC = MapViewController(feedItem: selectedFeedItem)
        navigationController?.pushViewController(mapVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        let isBottomReached = offsetY > contentHeight - scrollViewHeight
        if isBottomReached == true && isLoading == false {
            loadMore()
        }
    }
}

protocol FeedViewControllerDelegate: AnyObject {
    func feedViewControllerDidLogOut(_ viewController: FeedViewController)
}
