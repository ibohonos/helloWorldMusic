//
//  PlaylistSongView.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 16.07.2020.
//

import SwiftUI

struct PlaylistSongView: View {
    @Environment(\.imageCache) var cache: ImageCache

    @StateObject var model: PlaylistViewModel

    var body: some View {
        VStack {
            Text("\(model.playlist?.attributes?.name ?? "")")
            
            if let pls = model.playlists?.data.first?.relationships.tracks.data {
                Text("\(pls.count) songs")
                    .padding(.bottom)

                ForEach(pls, id: \.self.id) { pl in
                    VStack(alignment: .leading) {
                        HStack {
                            if let url = pl.attributes?.artwork.url,
                               let newURL = url.replacingOccurrences(of: "{w}", with: "\(240)").replacingOccurrences(of: "{h}", with: "\(240)") {
                                AsyncImage(url: URL(string: newURL)!, placeholder: Image(systemName: "photo"), cache: cache) { $0.resizable() }
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                            }
                            VStack(alignment: .leading) {
                                Text(pl.attributes?.name ?? "")
                                Text(pl.attributes?.artistName ?? "")
                            }
                        }

                        Divider()
                    }
                }
            }
        }
    }
}

struct PlaylistSongView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistSongView(model: PlaylistViewModel())
    }
}
