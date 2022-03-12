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
        guard let url = constructSignInRequestUrl(username: username, password: password) else {
            completion(.failure(AuthError.requestConstructFailed))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let authResponse = try? JSONDecoder().decode(AuthResponse.self, from: data),
                authResponse.status == .ok
            else {
                completion(.failure(AuthError.requestFailed))
                return
            }
            completion(.success(authResponse.code))
        }
        task.resume()
    }
    
    private func constructSignInRequestUrl(username: String, password: String) -> URL? {
        var components = URLComponents(string: Constants.API.auth)
        let usernameQueryItem = URLQueryItem(name: "username", value: username)
        let passwordQueryItem = URLQueryItem(name: "password", value: password)
        components?.queryItems = [usernameQueryItem, passwordQueryItem]
        return components?.url
    }
}
