//
//  API.swift
//  RappiCodeChallenge
//
//  Created by Vincent Villalta on 11/8/21.
//

import Foundation

fileprivate let baseUrl = "https://api.themoviedb.org/3/"
fileprivate let apiKey = "af7f60b3c0cf01ce3506f5a93a28cc62"

enum EncodingError: Error {
    case unableToEncode(String)
}

struct MoviesDBAPI {
    
    static func fetch(category: Category, page: Int) async throws -> MovieAPIResult {
        var url = baseUrl + "movie/"
        switch category {
        case .popular:
            url += "popular?api_key=\(apiKey)&page=\(page)"
        case .topRated:
            url += "top_rated?api_key=\(apiKey)&page=\(page)"
        case .upcoming:
            url += "upcoming?api_key=\(apiKey)&page=\(page)"
        case .nowPlaying:
            url += "now_playing?api_key=\(apiKey)&page=\(page)"
        case .onAir:
            break
        }
        
        return try await httpRequestJson(url: url)
    }
    
    static func search(_ string: String) async throws -> MovieAPIResult {
        guard let urlEncoded = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw EncodingError.unableToEncode("Error encoding \(string)")
        }

        return try await httpRequestJson(url: baseUrl + "search/movie?api_key=\(apiKey)&query=\(urlEncoded)")
    }
}


struct SeriesDBAPI {
    
    static func fetch(category: Category, page: Int) async throws -> SerieAPIResult {
        var url = baseUrl + "tv/"
        switch category {
        case .popular:
            url += "popular?api_key=\(apiKey)&page=\(page)"
        case .nowPlaying:
            break
        case .onAir:
            url += "on_the_air?api_key=\(apiKey)&page=\(page)"
        case .topRated:
            url += "top_rated?api_key=\(apiKey)&page=\(page)"
        case .upcoming:
            url += "upcoming?api_key=\(apiKey)&page=\(page)"
        }
        
        return try await httpRequestJson(url: url)
    }
    
    static func search(_ string: String) async throws -> SerieAPIResult {
        guard let urlEncoded = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw EncodingError.unableToEncode("Error encoding \(string)")
        }
        return try await httpRequestJson(url: baseUrl + "search/tv?api_key=\(apiKey)&query=\(urlEncoded)")
    }
}


struct VideosDBAPI {
    static func fetch(for videoId: String, type: FeedType) async throws -> VideosAPIResult {
        var url = baseUrl
        
        switch type {
        case .series:
            url += "tv/\(videoId)/videos?api_key=\(apiKey)"
        case .movies:
            url += "movie/\(videoId)/videos?api_key=\(apiKey)"
        }
        return try await httpRequestJson(url: url)
    }
}
