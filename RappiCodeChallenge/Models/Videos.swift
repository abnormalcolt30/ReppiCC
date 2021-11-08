//
//  Videos.swift
//  RappiCodeChallenge
//
//  Created by Vincent Villalta on 11/8/21.
//

import Foundation
struct VideosAPIResult: Codable, Equatable {
    var results: [Videos]
}

struct Videos: Codable, Equatable, Identifiable {
    var id: String {
        return key
    }
    var name: String
    var key: String
    var site: String
}
