//
//  ArtistSongView.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 16.07.2020.
//

import SwiftUI

struct ArtistSongView: View {
    @Environment(\.imageCache) var cache: ImageCache
    @EnvironmentObject private var player: PlayerViewModel

    @StateObject var model: PlaylistViewModel

    var body: some View {
        LazyVStack {
            Text("\(model.artist?.name ?? "")")
            
            if let artist = model.artists?.items {
                Text("\(artist.count) songs")
                    .padding(.bottom)
                
                ForEach(artist, id: \.self.etag) { art in
                    VStack(alignment: .leading) {
                        HStack {
                            ZStack {
                                AsyncImage(url: URL(string: art.snippet.thumbnails.medium.url)!, placeholder: Image(systemName: "photo"), cache: cache) { $0.resizable() }
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 60)
                                
                                if player.song.etag == art.etag && player.isPlayed {
                                    CustomSlider(value: .constant(0), range: (0, 100), sliderChangeHandler: { _ in }) { modifiers in
                                        ZStack {
                                            Color.accentColor
                                                .modifier(modifiers.barRight)
                                        }
                                        .clipShape(MagnitudeChart(values: player.randomCurrentPlay))
                                    }
                                    .padding(.vertical)
                                    .padding(.horizontal, 5)
                                    .background(Color.black.opacity(0.4))
                                    .frame(width: 60, height: 60)
                                }
                            }

                            VStack(alignment: .leading) {
                                Text(art.snippet.title)
                                    .lineLimit(1)
                                Text(art.snippet.snippetDescription)
                                    .lineLimit(1)
                            }
                        }
                        .onTapGesture(count: 1, perform: {
                            player.artists = artist
                            player.setupPlayer(song: art, selectedType: .artists)
                            player.loadVideo()
                        })

                        Divider()
                    }
                }
            }
        }
    }
}

struct ArtistSongView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistSongView(model: PlaylistViewModel())
    }
}
