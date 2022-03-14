//
//  Constants.swift
//  FeedApp
//
//  Created by Илья Билтуев on 12.03.2022.
//

import UIKit

struct Constants {
    
    struct API {
        static let authUrl = "http://www.alarstudios.com/test/auth.cgi"
        static let dataUrl = "http://www.alarstudios.com/test/data.cgi"
        static let itemsPerPage = 10
    }
    
    struct Map {
        static let radiusInMeters: Double = 5000
    }
    
    struct Color {
        static let blue = UIColor(hex: "#3EB5EF")!
    }
}
