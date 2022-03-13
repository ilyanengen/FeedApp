//
//  CacheService.swift
//  FeedApp
//
//  Created by Илья Билтуев on 14.03.2022.
//

import UIKit

final class CacheService {
    
    private let imageCache = NSCache<NSString, UIImage>()
    
    /// Load file from memory(NSCache) or download from internet. Returns a saved UIImage object.
    func loadImageUsingCache(url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let storageKey = url.absoluteString as NSString
        
        if let image = imageCache.object(forKey: storageKey) {
            completion(.success(image))
        } else {
            URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard
                    let self = self,
                    let data = data,
                    let downloadedImage = UIImage(data: data)
                else {
                    completion(.failure(APIError.requestFailed))
                    return
                }
                self.imageCache.setObject(downloadedImage, forKey: storageKey)
                completion(.success(downloadedImage))
            })
            .resume()
        }
    }
}
