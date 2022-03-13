//
//  APIError.swift
//  FeedApp
//
//  Created by Илья Билтуев on 12.03.2022.
//

import Foundation

enum APIError: Error {
    case requestConstructFailed
    case requestFailed
    case parsingFailed
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .requestConstructFailed:
            return NSLocalizedString("Failed to create a request.", comment: "")
        case .requestFailed:
            return NSLocalizedString("Request failed. Response code is not 200.", comment: "")
        case .parsingFailed:
            return NSLocalizedString("Parsing failed.", comment: "")
        }
    }
}
