//
//  ServiceLayer.swift
//  FeedApp
//
//  Created by Илья Билтуев on 12.03.2022.
//

import Foundation

final class ServiceLayer {
    static let shared = ServiceLayer()
    
    let authService = AuthService()
    let feedService = FeedService()
}
