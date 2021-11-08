//
//  Movie.swift
//  RappiCodeChallenge
//
//  Created by Vincent Villalta on 11/8/21.
//

import Foundation

struct MovieAPIResult: Codable, Equatable {
    var page: Int
    var totalPages: Int
    var totalResults: Int
    var results: [Movie]
}

struct Movie: Codable, Equatable, Identifiable {
    var adult: Bool?
    var id: Int?
    var title: String
    var overview: String?
    var posterPath: String?
    var video: Bool?
}
