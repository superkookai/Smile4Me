//
//  APIService.swift
//  Smile4Me
//
//  Created by Weerawut on 22/12/2568 BE.
//

import Foundation

class APIService {
    func getJSON<T: Decodable>(from url: String) async throws(APIError) -> T {
        guard let url = URL(string: url) else { throw .invalidURL }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw APIError.responseError
            }
            do {
                let decodedJokeData = try JSONDecoder().decode(T.self, from: data)
                return decodedJokeData
            } catch {
                throw APIError.decodingError(error.localizedDescription)
            }
        } catch {
            throw .dataTaskError(error.localizedDescription)
        }
    }
}

enum APIError: Error, LocalizedError {
    case invalidURL
    case responseError
    case dataTaskError(String)
    case decodingError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            NSLocalizedString("Invalid URL sent to API", comment: "")
        case .responseError:
            NSLocalizedString("Response Error from API", comment: "")
        case .dataTaskError(let message):
            NSLocalizedString("Return data was not valid: \(message)", comment: "")
        case .decodingError(let message):
            NSLocalizedString("Decoding Error: \(message)", comment: "")
        }
    }
}
