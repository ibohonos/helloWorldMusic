//
//  IndexView.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 08.07.2020.
//

import SwiftUI

struct IndexView: View {
    #if os(iOS)
    @Environment(\.horizontalSizeClass) var sizeClass
    #endif
    @Environment(\.imageCache) var cache: ImageCache
    
    @ObservedObject private var indexModel = IndexViewModel()

    @ViewBuilder
    var body: some View {
//        #if os(iOS)
//        if sizeClass == .compact {
            NavigationView {
                content
            }
            .navigationViewStyle(StackNavigationViewStyle())
//        } else {
//            content
//        }
//        #else
//            content
//        #endif
    }
    
    var content: some View {
        ZStack(alignment: .top) {
            BackgroundGradient()
            
            List {
                Section(header: LazyVStack(alignment: .leading) {
                    Text("YouTube Artists")
                        .font(.system(size: 24))
                        .foregroundColor(.firstText)
                }
                .padding(.horizontal)
                .background(LinearGradient(gradient: Gradient(colors: [.gradientFirstColor, .gradientSecondColor]), startPoint: .init(x: 0.25, y: 0.5), endPoint: .init(x: 0.75, y: 0.5)))
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                ) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: indexModel.artistColumn) {
                            ForEach(indexModel.Artists) { artist in
                                ArtistCell(artist: artist)
                                    .background(Color.firstBackground)
                                    .cornerRadius(12)
                                    .padding(.leading, indexModel.Artists.first == artist ? 20 : 0)
                                    .padding(.leading, indexModel.Artists[1] == artist ? 20 : 0)
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                    .padding(.horizontal, -20)
                }
                
                if let playlists = indexModel.Charts.results.playlists?.first?.data {
                    
                    Section(header: LazyVStack(alignment: .leading) {
                        Text("YouTube Featured")
                            .font(.system(size: 24))
                            .foregroundColor(.firstText)
                    }
                    .padding(.horizontal)
                    .background(LinearGradient(gradient: Gradient(colors: [.gradientFirstColor, .gradientSecondColor]), startPoint: .init(x: 0.25, y: 0.5), endPoint: .init(x: 0.75, y: 0.5)))
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    ) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHGrid(rows: indexModel.playlistColumn) {
                                ForEach(playlists, id: \.self.id) { playlist in
                                    PlaylistCell(playlist: playlist, cache: cache)
                                        .background(Color.firstBackground)
                                        .cornerRadius(12)
                                        .padding(.leading, playlists.first == playlist ? 20 : 0)
                                }
                            }
                        }
                        .listRowBackground(Color.clear)
                        .padding(.horizontal, -20)
                    }
                }
            }
            .alert(isPresented: $indexModel.showError) { self.indexModel.errorMessage }
        }
        .navigationBarSearch($indexModel.searchText, onTitleView: true)
        .onAppear {
            self.indexModel.getData()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct IndexView_Previews: PreviewProvider {
    static var previews: some View {
        IndexView()
    }
}
