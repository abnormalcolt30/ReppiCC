//
//  Http.swift
//  RappiCodeChallenge
//
//  Created by Vincent Villalta on 11/8/21.
//

import Foundation
enum HttpError : Error {
    case invalidURL
    case jsonParseError(Error)
    case connectionError(Error)
    case unknownError
}

func httpRequest(url: String) async throws -> Data {
    guard let compnents = URLComponents(string: url),
          let urlObj = compnents.url else {
        throw HttpError.invalidURL
    }
    
    let (data, _) = try await URLSession.shared.data(from: urlObj)
    return data
}

func httpRequestJson<T: Decodable>(url: String,
                                   keyStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase) async throws -> T {
    let data = try await httpRequest(url: url)
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = keyStrategy
    return try decoder.decode(T.self, from: data)
}
