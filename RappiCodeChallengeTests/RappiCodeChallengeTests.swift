//
//  RappiCodeChallengeTests.swift
//  RappiCodeChallengeTests
//
//  Created by Vincent Villalta on 11/8/21.
//

import XCTest
@testable import RappiCodeChallenge

class RappiCodeChallengeTests: XCTestCase {
    let mockedAPIResponse = MovieAPIResult(page: 1, totalPages: 1, totalResults: 1, results: [Movie(adult: false, id: 0, title: "Test API", overview: nil, posterPath: nil, video: false)])
    
    let secondMockedAPIResponse = MovieAPIResult(page: 1, totalPages: 1, totalResults: 1, results: [Movie(adult: false, id: 1, title: "Test API", overview: nil, posterPath: nil, video: false)])

    func testMovieRepository() {
        let cache = NSCache<NSString, StructWrapper<[Movie]>>()
        let cacheKey = "Movies\(Category.popular.rawValue)"
        
        let response = mockedAPIResponse
        cache.setObject(StructWrapper<[Movie]>(response.results), forKey: cacheKey as NSString)
        
        XCTAssert(response.results.count == 1)
        
        let cachedVersion = cache.object(forKey: cacheKey as NSString)
        XCTAssert(cachedVersion?.value.count == 1)
    }

    func testIncrementalCache() {
        let cache = NSCache<NSString, StructWrapper<[Movie]>>()
        let cacheKey = "Movies\(Category.popular.rawValue)"
        
        let response = mockedAPIResponse
        XCTAssert(response.results.count == 1)
        
        let secondResponse = secondMockedAPIResponse
        XCTAssert(response.results != secondResponse.results)
        
        cache.setObject(StructWrapper<[Movie]>(response.results), forKey: cacheKey as NSString)
        let cachedVersion = cache.object(forKey: cacheKey as NSString)
        XCTAssert(cachedVersion?.value.count == 1)
        
         
        cache.setObject(StructWrapper<[Movie]>(response.results + secondResponse.results), forKey: cacheKey as NSString)
        var secondCacheVersion = cache.object(forKey: cacheKey as NSString)
        XCTAssert(secondCacheVersion?.value.count == 2)
    }
    
    func testOffline() {
        let cache = NSCache<NSString, StructWrapper<[Movie]>>()
        let cacheKey = "Movies\(Category.popular.rawValue)"
        let internetConnection = false
        
        let response = mockedAPIResponse
        XCTAssert(response.results.count == 1)
        
        let secondResponse = secondMockedAPIResponse
        XCTAssert(response.results != secondResponse.results)
        
        cache.setObject(StructWrapper<[Movie]>(response.results), forKey: cacheKey as NSString)
        let cachedVersion = cache.object(forKey: cacheKey as NSString)
        XCTAssert(cachedVersion?.value.count == 1)
        
        var data: [Movie] = secondResponse.results
        
        if !internetConnection {
            data = cachedVersion?.value ?? []
        }
        XCTAssert(data != secondResponse.results)
        
    }

}
