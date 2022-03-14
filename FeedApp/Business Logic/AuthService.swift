//
//  AuthService.swift
//  FeedApp
//
//  Created by Илья Билтуев on 12.03.2022.
//

import Foundation

typealias Code = String

final class AuthService {
    
    var code: String? {
        get {
            return UserDefaults.standard.object(forKey: "code") as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "code")
        }
    }
    
    func signIn(username: String, password: String, completion: @escaping (Result<Code, Error>) -> Void) {
        guard let signInRequest = constructSignInRequest(username: username, password: password) else {
            completion(.failure(APIError.requestConstructFailed))
            return
        }
        let task = URLSession.shared.dataTask(with: signInRequest) { [weak self] data, response, error in
            guard let self = self else { return }
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
            case .ok:
                self.code = authResponse.code
                completion(.success(authResponse.code))
            case .error:
                completion(.failure(APIError.requestFailed))
            }
        }
        task.resume()
    }
    
    func logout() {
        code = nil
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
