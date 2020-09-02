//
//  HomeView.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 07.07.2020.
//

import SwiftUI

enum Tabs: Int {
    case home, search, playlists, myMusic, settings
}

struct HomeView: View {
    #if os(iOS)
    @Environment(\.horizontalSizeClass) var sizeClass
    #endif
    @EnvironmentObject private var settings: SettingsViewModel
    @EnvironmentObject private var player: PlayerViewModel

    var body: some View {
        Group {
//            #if os(iOS)
//                if sizeClass == .compact {
                    TabBar()
//                } else {
//                    Sidebar()
//                }
//            #else
//                Sidebar()
//            #endif
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView()
            HomeView()
                .preferredColorScheme(.dark)
            HomeView()
                .previewDevice("iPad Pro (11-inch) (2nd generation)")
        }
        .environmentObject(SettingsViewModel())
        .environmentObject(PlayerViewModel())
    }
}
