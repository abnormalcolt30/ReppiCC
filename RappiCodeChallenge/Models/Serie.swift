//
//  Serie.swift
//  RappiCodeChallenge
//
//  Created by Vincent Villalta on 11/8/21.
//

import Foundation

struct SerieAPIResult: Codable, Equatable {
    var page: Int?
    var totalPages: Int?
    var totalResults: Int?
    var results: [Serie]
}

struct Serie: Codable, Equatable, Identifiable {
    var id: String {
        return name
    }
    var name: String
    var overview: String
    var posterPath: String?
}
