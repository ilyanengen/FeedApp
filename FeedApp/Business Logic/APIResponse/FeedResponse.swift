//
//  FeedResponse.swift
//  FeedApp
//
//  Created by Илья Билтуев on 13.03.2022.
//

import Foundation

struct FeedResponse: Decodable {
    let status: APIRequestStatus
    let page: Int
    let data: [FeedItem]
}
