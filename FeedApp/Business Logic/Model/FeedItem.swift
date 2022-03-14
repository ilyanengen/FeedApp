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
    var imageUrl: URL?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: FeedItem, rhs: FeedItem) -> Bool {
        return lhs.id == rhs.id
    }
}

extension FeedItem {
    enum CodingKeys: CodingKey {
        case id, country, lat, lon, name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.country = try container.decode(String.self, forKey: .country)
        self.lat = try container.decode(Double.self, forKey: .lat)
        self.lon = try container.decode(Double.self, forKey: .lon)
        self.name = try container.decode(String.self, forKey: .name)
        self.imageUrl = generateImageUrl()
    }
    
    private func generateImageUrl() -> URL {
        let randomImageId = String(Int.random(in: 1..<50))
        let string = "https://picsum.photos/id/" + randomImageId + "/300"
        return URL(string: string)!
    }
}
