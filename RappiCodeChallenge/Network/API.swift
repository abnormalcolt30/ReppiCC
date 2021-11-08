//
//  API.swift
//  RappiCodeChallenge
//
//  Created by Vincent Villalta on 11/8/21.
//

import Foundation

fileprivate let baseUrl = "https://api.themoviedb.org/3/"
fileprivate let apiKey = "af7f60b3c0cf01ce3506f5a93a28cc62"

struct MoviesDBAPI {
    
    static func fetch(category: Category) async throws -> MovieAPIResult {
        var url = baseUrl + "movie/"
        switch category {
        case .popular:
            url += "popular?api_key=\(apiKey)"
        case .topRated:
            url += "top_rated?api_key=\(apiKey)"
        case .upcoming:
            url += "upcoming?api_key=\(apiKey)"
        }
        
        return try await httpRequestJson(url: url)
    }
}


struct SeriesDBAPI {
    
    static func fetch(category: Category) async throws -> SerieAPIResult {
        var url = baseUrl + "tv/"
        switch category {
        case .popular:
            url += "popular?api_key=\(apiKey)"
        case .topRated:
            url += "top_rated?api_key=\(apiKey)"
        case .upcoming:
            url += "upcoming?api_key=\(apiKey)"
        }
        
        return try await httpRequestJson(url: url)
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
