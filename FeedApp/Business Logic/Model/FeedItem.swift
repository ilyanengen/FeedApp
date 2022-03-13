//
//  FeedItem.swift
//  FeedApp
//
//  Created by Илья Билтуев on 13.03.2022.
//

import Foundation

struct FeedItem: Decodable, Hashable {
    let id: String
    let country: String
    let lat: Double
    let lon: Double
    let name: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: FeedItem, rhs: FeedItem) -> Bool {
        return lhs.id == rhs.id
    }
}
