//
//  FeedCell.swift
//  FeedApp
//
//  Created by Илья Билтуев on 13.03.2022.
//

import UIKit

class FeedCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(feedItem: FeedItem) {
        
    }
}

extension FeedCell {
    static var reuseIdentifier: String { return String(describing: Self.self) }
}
