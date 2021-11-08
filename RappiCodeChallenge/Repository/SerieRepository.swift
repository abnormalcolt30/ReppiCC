//
//  SerieRepository.swift
//  RappiCodeChallenge
//
//  Created by Vincent Villalta on 11/8/21.
//

import Foundation
enum SerieError: Error {
    case requestFailed
    case parseError
    case invalidCache
}

protocol SerieRepositoryProtocol {
    func fetchSeries(_ category: Category) async throws -> SerieAPIResult?
}

final class SerieRepository: SerieRepositoryProtocol {
    let cache = NSCache<NSString, StructWrapper<[Serie]>>()
    func fetchSeries(_ category: Category) async throws -> SerieAPIResult? {
        let cacheKey = "Serie\(category.rawValue)"
        if NetworkMonitor.shared.connected {
            let response = try await SeriesDBAPI.fetch(category: category)
            storeInCache(response.results, key: cacheKey)
            return response
        } else {
            if let cachedVersion = cache.object(forKey: cacheKey as NSString) {
                return SerieAPIResult(page: 0, totalPages: 0, totalResults: cachedVersion.value.count, results: cachedVersion.value)
            }
            return nil
        }
    }
    
    private func storeInCache(_ response: [Serie], key: String) {
        if let cachedVersion = cache.object(forKey: key as NSString) {
            cache.setObject(StructWrapper<[Serie]>(cachedVersion.value + response ), forKey: key as NSString)
        } else {
            cache.setObject(StructWrapper<[Serie]>(response), forKey: key as NSString)
        }
    }
}
