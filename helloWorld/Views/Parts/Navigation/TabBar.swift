//
//  TabBar.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 11.07.2020.
//

import SwiftUI

struct TabBar: View {
    @EnvironmentObject private var player: PlayerViewModel
    @State private var selectedTab: Tabs? = .home

    var body: some View {
        ZStack(alignment: .bottom) {
            BackgroundGradient()

            SelectedView(selectedTab: $selectedTab)
                .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 70  + (player.viewPlayer && player.isCollapsed ? 86 : 0) : UIApplication.shared.windows.first!.safeAreaInsets.bottom + 66 + (player.viewPlayer && player.isCollapsed ? 86 : 0))
            
            if player.viewPlayer {
                PlayerView()
                    .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 15 : UIApplication.shared.windows.first?.safeAreaInsets.bottom)
            }
            
            if player.isCollapsed {
                tabbar
            }
        }
        .edgesIgnoringSafeArea([.bottom, .horizontal])
    }
    
    var tabbar: some View {
        HStack {
            TabbarItem(selectedTab: $selectedTab, image: "house", tab: .home)
            Spacer()
            TabbarItem(selectedTab: $selectedTab, image: "magnifyingglass", tab: .search)
            Spacer()
            TabbarItem(selectedTab: $selectedTab, image: "music.note.list", tab: .playlists)
            Spacer()
            TabbarItem(selectedTab: $selectedTab, image: "music.note.house", tab: .myMusic)
            Spacer()
            TabbarItem(selectedTab: $selectedTab, image: "gear", tab: .settings)
        }
        .padding(.top, 12)
        .padding(.horizontal, 30)
        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 15 : UIApplication.shared.windows.first?.safeAreaInsets.bottom)
        .background(Color.firstBackground)
//        .clipShape(CSShape(size: 25))
        .shadow(radius: 10)
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TabBar()
            TabBar()
                .preferredColorScheme(.dark)
        }
        .environmentObject(SettingsViewModel())
        .environmentObject(PlayerViewModel())
    }
}
