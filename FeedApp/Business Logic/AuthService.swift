//
//  AuthService.swift
//  FeedApp
//
//  Created by Илья Билтуев on 12.03.2022.
//

import Foundation

typealias Code = String

final class AuthService {
    
    func signIn(username: String, password: String, completion: @escaping (Result<Code, Error>) -> Void) {
        guard let signInRequest = constructSignInRequest(username: username, password: password) else {
            completion(.failure(APIError.requestConstructFailed))
            return
        }
        let task = URLSession.shared.dataTask(with: signInRequest) { data, response, error in
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
            guard let authResponse = try? JSONDecoder().decode(AuthResponse.self, from: data) else {
                completion(.failure(APIError.parsingFailed))
                return
            }
            switch authResponse.status {
            case .ok    : completion(.success(authResponse.code))
            case .error : completion(.failure(APIError.requestFailed))
            }
        }
        task.resume()
    }

    private func constructSignInRequest(username: String, password: String) -> URLRequest? {
        var components = URLComponents(string: Constants.API.authUrl)
        let usernameQueryItem = URLQueryItem(name: "username", value: username)
        let passwordQueryItem = URLQueryItem(name: "password", value: password)
        components?.queryItems = [usernameQueryItem, passwordQueryItem]
        guard let url = components?.url else { return nil }
        return URLRequest(url: url)
    }
}
