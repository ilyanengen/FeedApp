//
//  AuthResponse.swift
//  FeedApp
//
//  Created by Илья Билтуев on 12.03.2022.
//

import Foundation

enum APIRequestStatus: String, Decodable {
    case ok
    case error
}

struct AuthResponse: Decodable {
    let status: APIRequestStatus
    let code: String
}
