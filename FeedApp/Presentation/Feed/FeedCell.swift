//
//  FeedCell.swift
//  FeedApp
//
//  Created by Илья Билтуев on 13.03.2022.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var countryLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    func configure(feedItem: FeedItem) {
        nameLabel.text = feedItem.name
        countryLabel.text = feedItem.country
        photoImageView.loadImageUsingCache(url: feedItem.imageUrl)
    }
}

extension FeedCell {
    static var reuseIdentifier: String { return String(describing: Self.self) }
}
