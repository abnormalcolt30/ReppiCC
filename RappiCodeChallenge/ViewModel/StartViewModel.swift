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
    
    case nowPlaying = "Now Playing"
    case onAir = "On the air"
}

class StartViewModel: ObservableObject {
    var feedOptions: [FeedType] = FeedType.allCases
    var sorting: [Category] = [.popular, .topRated]
    
    @Published var selectedFeed: FeedType = .movies
    @Published var selectedSort: Category = .popular
    @Published var loading: Bool = false
    
    @Published var movies: [Movie] = []
    @Published var series: [Serie] = []
    
    private var page: [String: Int] = [:]
    
    private var task: Task<Void, Never>?
    
    func fetchData() {
        loading = true
        
        self.task = Task<Void, Never> {
            do {
                switch selectedFeed {
                case .movies:
                    let response = try await MovieRepository().fetchMovies(selectedSort, page: self.fetchCurrentPage())
                    self.storeCurrenPage(response?.page)
                    DispatchQueue.main.async {
                        self.movies.append(contentsOf: response?.results ?? [])
                    }
                case .series:
                    let response = try await SerieRepository().fetchSeries(selectedSort, page: self.fetchCurrentPage())
                    self.storeCurrenPage(response?.page)
                    DispatchQueue.main.async {
                        self.series.append(contentsOf: response?.results ?? [])
                    }
                }
            } catch {
                
            }
            DispatchQueue.main.async {
                self.loading = false
            }
            
        }
        
        
    }
    
    func fetchOnlineResults(_ text: String) {
        guard NetworkMonitor.shared.connected else { return }
        //If user deletes the content, or the field is empty....
        if text.isEmpty {
            self.fetchData()
            return
        }
        loading = true
        self.task = Task<Void, Never> {
            do {
                switch selectedFeed {
                case .movies:
                    let response = try await MovieRepository().searchMovies(text)
                    DispatchQueue.main.async {
                        self.movies = response?.results ?? []
                    }
                case .series:
                    let response = try await SerieRepository().searchSeries(text)
                    DispatchQueue.main.async {
                        self.series = response?.results ?? []
                    }
                }
            } catch {
                
            }
        }
    }
    
    func storeCurrenPage(_ page: Int?) {
        guard let page = page else {
            return
        }

        self.page["\(selectedFeed.rawValue)\(selectedSort.rawValue)"] = page
    }
    
    func fetchCurrentPage() -> Int {
        return self.page["\(selectedFeed.rawValue)\(selectedSort.rawValue)"] ?? 1
    }
    
    func resetPagination() {
        self.page = [:]
        self.movies = []
        self.series = []
    }
    
    deinit {
        self.task?.cancel()
    }
    
}
