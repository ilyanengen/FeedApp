//
//  AuthResponse.swift
//  FeedApp
//
//  Created by Илья Билтуев on 12.03.2022.
//

import Foundation

enum AuthResponseStatus: String, Decodable {
    case ok
    case error
}

struct AuthResponse: Decodable {
    let status: AuthResponseStatus
    let code: String
}
