//
//  PlaylistView.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 16.07.2020.
//

import SwiftUI

struct PlaylistView: View {
    @Environment(\.imageCache) var cache: ImageCache
    @ObservedObject private var model = PlaylistViewModel()
    
    @State var title: String = ""
    
    init(_ selectedType: TypeHomeList,
         artist: TopArtists? = nil,
         playlist: PlaylistDatum? = nil
    ) {
        model.selectedType = selectedType
        model.artist = artist
        model.playlist = playlist
    }
    
    var body: some View {
        ZStack {
            BackgroundGradient()

            ScrollView(.vertical, showsIndicators: false, content: {
                GeometryReader { reader in
                    switch model.selectedType {
                    case .artists:
                        Image(model.artist?.image ?? "")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .offset(y: -reader.frame(in: .global).minY)
                            .frame(height: reader.frame(in: .global).minY + 300)
                    case .playlist:
                        if let url = model.playlist?.attributes?.artwork.url,
                           let newURL = url.replacingOccurrences(of: "{w}", with: "\(model.playlist?.attributes?.artwork.width ?? 240)").replacingOccurrences(of: "{h}", with: "\(model.playlist?.attributes?.artwork.height ?? 240)") {
                            AsyncImage(url: URL(string: newURL)!, placeholder: Image(systemName: "photo"), cache: cache) { $0.resizable() }
                                .aspectRatio(contentMode: .fill)
                                .offset(y: -reader.frame(in: .global).minY)
                                .frame(height: reader.frame(in: .global).minY + 300)
                        }
                    default:
                        EmptyView()
                    }
                }
                .frame(height: 300)
                .blur(radius: 20)

                ZStack(alignment: .top) {
                    VStack {
                        switch model.selectedType {
                            case .artists:
                                ArtistSongView(model: model)
                            case .playlist:
                                PlaylistSongView(model: model)
                            default:
                                Text("Hello, World! Other")
                        }
                    }
                    .padding(.top, 100)
                    .padding(.horizontal)
                    .background(LinearGradient(gradient: Gradient(colors: [.gradientFirstColor, .gradientSecondColor]), startPoint: .init(x: 0.25, y: 0.5), endPoint: .init(x: 0.75, y: 0.5)))
                    .clipShape(CSShape(size: 50))
                    .offset(y: -50)

                    VStack {
                        switch model.selectedType {
                        case .artists:
                            Image(model.artist?.image ?? "")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
//                                .clipShape(ContainerRelativeShape())
                                .cornerRadius(20)
                        case .playlist:
                            if let url = model.playlist?.attributes?.artwork.url,
                               let newURL = url.replacingOccurrences(of: "{w}", with: "\(240)").replacingOccurrences(of: "{h}", with: "\(240)") {
                                AsyncImage(url: URL(string: newURL)!, placeholder: Image(systemName: "photo"), cache: cache) { $0.resizable() }
                                    .aspectRatio(contentMode: .fill)
//                                    .clipShape(ContainerRelativeShape())
                                    .cornerRadius(20)
                            }
                        default:
                            EmptyView()
                        }
                    }
                    .padding(10)
                    .background(Color.firstBackground)
                    .frame(width: 180, height: 180)
                    .cornerRadius(20)
                    .offset(y: -150)
                }
                .alert(isPresented: $model.showError) { model.errorMessage }
            })
            .edgesIgnoringSafeArea(.all)
        }
        .navigationBarTitle(Text(title))
        .onAppear {
            if let art = model.artist {
                title = art.name
                model.id = art.name
                model.fetchPlaylistItems()
            }
            
            if let pl = model.playlist {
                title = pl.attributes?.name ?? ""
                model.id = pl.id
                model.fetchSongs()
            }
        }
    }
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PlaylistView(.artists, artist: DebugArtists.first, playlist: DebugPlaylist)
            PlaylistView(.artists, artist: DebugArtists.first, playlist: DebugPlaylist)
                .preferredColorScheme(.dark)
                .previewDevice("iPad Pro (11-inch) (2nd generation)")
        }
    }
}
