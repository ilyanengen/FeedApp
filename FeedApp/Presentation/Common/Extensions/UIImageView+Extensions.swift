//
//  UIImageView+Extensions.swift
//  FeedApp
//
//  Created by Илья Билтуев on 14.03.2022.
//

import UIKit

extension UIImageView {
    func loadImageUsingCache(url: URL?) {
        image = nil
        guard let url = url else { return }
        ServiceLayer.shared.cacheService.loadImageUsingCache(url: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let downloadedImage):
                    self.image = downloadedImage
                }
            }
        }
    }
}
