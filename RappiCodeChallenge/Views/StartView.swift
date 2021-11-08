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
                .onChange(of: viewModel.selectedSort, perform: { _ in
                    viewModel.fetchData()
                })
                
                Picker("", selection: $viewModel.selectedSort) {
                    ForEach(viewModel.sorting, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: viewModel.selectedSort, perform: { _ in
                    viewModel.fetchData()
                })
                
                switch viewModel.selectedFeed {
                case .movies:
                    List(viewModel.movies.filter({ searchText.isEmpty ? true : $0.title.contains(searchText) }), rowContent: { item in
                        NavigationLink {
                            DetailView(object: .movie(item), viewModel: DetailsViewModel())
                        } label: {
                            MoviewCell(item: item)
                        }
                    })
                    
                case .series:
                    List(viewModel.series.filter({ searchText.isEmpty ? true : $0.name.contains(searchText) }), rowContent: { item in
                        NavigationLink {
                            DetailView(object: .serie(item), viewModel: DetailsViewModel())
                        } label: {
                            SerieCell(item: item)
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
        }
        
        
    }

}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView(viewModel: StartViewModel())
    }
}
