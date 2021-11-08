//
//  MoviewCell.swift
//  RappiCodeChallenge
//
//  Created by Vincent Villalta on 11/8/21.
//

import SwiftUI

struct MoviewCell: View {
    let item: Movie
    var body: some View {
        HStack {
            if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500/\(item.posterPath ?? "")") {
                AsyncImage(url: imageUrl, content: { image in
                    image.resizable()
                         .aspectRatio(contentMode: .fit)
                         .frame(maxWidth: 80, maxHeight: 120)
                },
                placeholder: {
                    ProgressView()
                }).frame(width: 80, height: 120)
            }
            VStack(alignment: .leading) {
                Text(item.title).font(Font.headline)
                Text(item.overview ?? "").lineLimit(3).font(Font.caption)
            }
            
            Spacer()
        }
    }
}

struct MoviewCell_Previews: PreviewProvider {
    static var previews: some View {
        MoviewCell(item: Movie(adult: false, id: 1, title: "Test", overview: "test moview", posterPath: "kqjL17yufvn9OVLyXYpvtyrFfak.jpg", video: false))
    }
}
