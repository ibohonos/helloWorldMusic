//
//  PlaylistsView.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 15.07.2020.
//

import SwiftUI

struct PlaylistsView: View {
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
        ZStack {
            BackgroundGradient()

            Text("Hello, World! Playlists")
        }
        .navigationTitle("Playlists")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PlaylistsView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistsView()
    }
}
