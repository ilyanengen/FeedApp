//
//  FeedService.swift
//  FeedApp
//
//  Created by Илья Билтуев on 13.03.2022.
//

import Foundation

final class FeedService {
    
    func fetchFeedItems(code: Code, offset: Int, completion: @escaping (Result<[FeedItem], Error>) -> Void) {
        guard let feedRequest = constructFeedRequest(code: code, offset: offset) else {
            completion(.failure(APIError.requestConstructFailed))
            return
        }
        let task = URLSession.shared.dataTask(with: feedRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200
            else {
                completion(.failure(APIError.requestFailed))
                return
            }
            guard let feedResponse = try? JSONDecoder().decode(FeedResponse.self, from: data) else {
                completion(.failure(APIError.parsingFailed))
                return
            }
            switch feedResponse.status {
            case .ok    : completion(.success(feedResponse.data))
            case .error : completion(.failure(APIError.requestFailed))
            }
        }
        task.resume()
    }
    
    private func constructFeedRequest(code: Code, offset: Int) -> URLRequest? {
        var components = URLComponents(string: Constants.API.dataUrl)
        let codeQueryItem = URLQueryItem(name: "code", value: code)
        // Pages numeration starts from 1.
        let pageValue = String((offset / Constants.API.itemsPerPage) + 1)
        let pageQueryItem = URLQueryItem(name: "p", value: pageValue)
        components?.queryItems = [codeQueryItem, pageQueryItem]
        guard let url = components?.url else { return nil }
        return URLRequest(url: url)
    }
}
