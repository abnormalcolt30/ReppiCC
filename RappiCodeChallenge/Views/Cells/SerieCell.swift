//
//  SerieCell.swift
//  RappiCodeChallenge
//
//  Created by Vincent Villalta on 11/8/21.
//

import SwiftUI

struct SerieCell: View {
    let item: Serie
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
                Text(item.name)
                Text(item.overview).lineLimit(3)
            }
            
            Spacer()
        }
    }
}

struct SerieCell_Previews: PreviewProvider {
    static var previews: some View {
        SerieCell(item: Serie(name: "Test", overview: "test serie", posterPath: ""))
    }
}
