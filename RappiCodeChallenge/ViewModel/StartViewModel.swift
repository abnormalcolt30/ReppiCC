//
//  StartViewModel.swift
//  RappiCodeChallenge
//
//  Created by Vincent Villalta on 11/8/21.
//

import UIKit
import Combine

enum FeedType: String, CaseIterable {
    case movies = "Movies"
    case series = "Series"
}

enum Category: String, CaseIterable {
    case popular = "Popular"
    case topRated = "Top Rated"
    case upcoming = "Upcoming"
}

class StartViewModel: ObservableObject {
    var feedOptions: [FeedType] = FeedType.allCases
    var sorting: [Category] = Category.allCases
    
    @Published var selectedFeed: FeedType = .movies
    @Published var selectedSort: Category = .popular
    @Published var loading: Bool = false
    
    @Published var movies: [Movie] = []
    @Published var series: [Serie] = []
    
    private var task: Task<Void, Never>?
    
    func fetchData() {
        loading = true
        
        self.task = Task<Void, Never> {
            do {
                switch selectedFeed {
                case .movies:
                    let response = try await MovieRepository().fetchMovies(selectedSort)
                    DispatchQueue.main.async {
                        self.movies = response?.results ?? []
                    }
                case .series:
                    let response = try await SerieRepository().fetchSeries(selectedSort)
                    DispatchQueue.main.async {
                        self.series = response?.results ?? []
                    }
                }
            } catch {
                
            }
            DispatchQueue.main.async {
                self.loading = false
            }
            
        }
        
        
    }
    
    deinit {
        self.task?.cancel()
    }
    
}
