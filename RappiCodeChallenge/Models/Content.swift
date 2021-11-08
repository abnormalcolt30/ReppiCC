//
//  Content.swift
//  RappiCodeChallenge
//
//  Created by Vincent Villalta on 11/8/21.
//

import Foundation

enum ContentWrapper<T> {
    case movie(_ data: Movie)
    case serie(_ data: Serie)
}

protocol Content {}
extension Movie: Content {}
extension Serie: Content {}
