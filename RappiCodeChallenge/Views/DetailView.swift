//
//  DetailView.swift
//  RappiCodeChallenge
//
//  Created by Vincent Villalta on 11/8/21.
//

import SwiftUI
import Combine
import AVKit
struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var object: ContentWrapper<Content>
    @ObservedObject var viewModel: DetailsViewModel
    var body: some View {
        ZStack {            
            ScrollView {
                if let imageUrl = getPosterURL() {
                    GeometryReader { geometry in
                        ZStack {
                            if geometry.frame(in: .global).minY <= 0 {
                                AsyncImage(url: imageUrl, content: { image in
                                    image.resizable()
                                         .aspectRatio(contentMode: .fill)
                                         .frame(width: geometry.size.width, height: geometry.size.height)
                                         .offset(y: geometry.frame(in: .global).minY/9)
                                         .clipped()
                                },
                                placeholder: {
                                    ProgressView()
                                })
                            } else {
                                AsyncImage(url: imageUrl, content: { image in
                                    image.resizable()
                                         .aspectRatio(contentMode: .fill)
                                         .frame(width: geometry.size.width, height: geometry.size.height + geometry.frame(in: .global).minY)
                                         .clipped()
                                         .offset(y: -geometry.frame(in: .global).minY)
                                },
                                placeholder: {
                                    ProgressView()
                                })
                            }
                        }
                    }.frame(height: 400)
                }
                
                VStack(alignment: .leading) {
                    Text(getTitle())
                        .font(Font.headline)
                        .padding(.top, 20)
                    Text(getContent())
                        .font(Font.body)
                        .lineLimit(nil)
                        .padding(.top, 30)
                    

                    ForEach(viewModel.videos, id: \.self) { item in
                        if let url = URL(string: item){
                            VideoPlayer(player: AVPlayer(url: url))
                                .frame(height: 400)
                            Link(item, destination: url)
                        }
                        
                    }
                    
                }
                .frame(width: 350)
            }
            .edgesIgnoringSafeArea(.top)
            
            
        }.onAppear {
            viewModel.fetchVideos(getIdAndType().0, type: getIdAndType().1)
        }
            
        
    }
    
    private func getTitle() -> String {
        switch object {
        case .movie(let data):
            return data.title
        case .serie(let data):
            return data.name
        }
    }
    
    private func getContent() -> String {
        switch object {
        case .movie(let data):
            return data.overview ?? ""
        case .serie(let data):
            return data.overview
        }
    }
    
    
    private func getPosterURL() -> URL? {
        switch object {
        case .movie(let data):
            return URL(string: "https://image.tmdb.org/t/p/w500/\(data.posterPath ?? "")")
        case .serie(let data):
            return URL(string: "https://image.tmdb.org/t/p/w500/\(data.posterPath ?? "")")
        }
    }
    
    private func getIdAndType() -> (String, FeedType) {
        switch object {
        case .movie(let data):
            return ("\(data.id  ?? 0)", .movies)
        case .serie(let data):
            return (data.id, .series)
        }
    }
}
