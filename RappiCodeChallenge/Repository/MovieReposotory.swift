//
//  MovieReposotory.swift
//  RappiCodeChallenge
//
//  Created by Vincent Villalta on 11/8/21.
//

import Foundation

enum MovieError: Error {
    case requestFailed
    case parseError
    case invalidCache
}

protocol MovieRepositoryProtocol {
    func fetchMovies(_ category: Category) async throws -> MovieAPIResult?
}

final class MovieRepository: MovieRepositoryProtocol {
    let cache = NSCache<NSString, StructWrapper<[Movie]>>()
    func fetchMovies(_ category: Category) async throws -> MovieAPIResult? {
        let cacheKey = "Movies\(category.rawValue)"
        if NetworkMonitor.shared.connected {
            let response = try await MoviesDBAPI.fetch(category: category)
            storeInCache(response.results, key: cacheKey)
            return response
        } else {
            if let cachedVersion = cache.object(forKey: cacheKey as NSString) {
                return MovieAPIResult(page: 0, totalPages: 0, totalResults: cachedVersion.value.count, results: cachedVersion.value)
            }
            return nil
        }
    }
    
    private func storeInCache(_ response: [Movie], key: String) {
        if let cachedVersion = cache.object(forKey: key as NSString) {
            cache.setObject(StructWrapper<[Movie]>(cachedVersion.value + response ), forKey: key as NSString)
        } else {
            cache.setObject(StructWrapper<[Movie]>(response), forKey: key as NSString)
        }
    }
}
