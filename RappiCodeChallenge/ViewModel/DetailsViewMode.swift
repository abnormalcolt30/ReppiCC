//
//  DetailsViewMode.swift
//  RappiCodeChallenge
//
//  Created by Vincent Villalta on 11/8/21.
//

import Foundation
import Combine

class DetailsViewModel: ObservableObject {
    @Published var videos: [String] = []
    
    private var task: Task<Void, Never>?
    func fetchVideos(_ videoId: String, type: FeedType) {
        self.task = Task<Void, Never> {
            do {
                let response = try await VideosDBAPI.fetch(for: videoId, type: type)
                DispatchQueue.main.async {
                    self.videos = response.results.compactMap { self.convert($0) }
                }
            } catch {
                
            }
        }
    }
    
    private func convert(_ video: Videos) -> String {
        switch video.site.lowercased() {
        case "youtube":
            return "https://youtube.com/watch?v=\(video.key)"
        default:
            return ""
        }
    }
    
    deinit {
        self.task?.cancel()
    }
}
