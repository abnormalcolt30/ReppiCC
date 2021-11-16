//
//  StartView.swift
//  RappiCodeChallenge
//
//  Created by Vincent Villalta on 11/8/21.
//

import SwiftUI
import Combine
struct StartView: View {
    @ObservedObject var viewModel: StartViewModel
    @State private var searchText = ""
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                Picker("", selection: $viewModel.selectedFeed) {
                    ForEach(viewModel.feedOptions, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                
                Picker("", selection: $viewModel.selectedSort) {
                    switch viewModel.selectedFeed {
                    case .series:
                        ForEach(viewModel.sorting + [.onAir], id: \.self) {
                            Text($0.rawValue)
                        }
                    case .movies:
                        ForEach(viewModel.sorting + [.upcoming, .nowPlaying], id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                }
                .pickerStyle(.segmented)
                
                switch viewModel.selectedFeed {
                case .movies:
                    List(viewModel.movies.filter({ searchText.isEmpty ? true : $0.title.contains(searchText) }), rowContent: { item in
                        NavigationLink {
                            DetailView(object: .movie(item), viewModel: DetailsViewModel())
                        } label: {
                            MoviewCell(item: item)
                            
                            
                        }
                        if self.viewModel.movies.isLastItem(item) {
                            Text("Fetching more...")
                                .onAppear(perform: {
                                    self.viewModel.fetchData()
                                })
                        }
                        
                    })
                    
                case .series:
                    List(viewModel.series.filter({ searchText.isEmpty ? true : $0.name.contains(searchText) }), rowContent: { item in
                        NavigationLink {
                            DetailView(object: .serie(item), viewModel: DetailsViewModel())
                        } label: {
                            SerieCell(item: item)
                        }
                        
                        if self.viewModel.series.isLastItem(item) {
                            Text("Fetching more...")
                                .onAppear(perform: {
                                    self.viewModel.fetchData()
                                })
                        }
                    })
                }
                Spacer()
            
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.top)
            .padding()
        }
        .onAppear {
            viewModel.fetchData()
        }.onChange(of: searchText) { newValue in
            viewModel.fetchOnlineResults(newValue)
        }.onChange(of: viewModel.selectedSort, perform: { _ in
            viewModel.resetPagination()
            viewModel.fetchData()
        }).onChange(of: viewModel.selectedFeed) { newValue in
            viewModel.resetPagination()
            viewModel.selectedSort = .popular
            viewModel.fetchData()
            
        }
        
        
    }

}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView(viewModel: StartViewModel())
    }
}
