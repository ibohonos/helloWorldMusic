//
//  Sidebar.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 11.07.2020.
//

import SwiftUI

struct Sidebar: View {
    @Environment(\.horizontalSizeClass) var sizeClass

    @State private var selectedTab: Tabs? = .home

    var body: some View {
        NavigationView {
            #if os(iOS)
                sidebar
                    .navigationTitle("")
                    .navigationBarHidden(true)
            #else
                sidebar
                    .frame(minWidth: 100, idealWidth: 150, maxWidth: 200, maxHeight: .infinity)
            #endif
        }
//        .navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
    
    var sidebar: some View {
        List {
            NavigationLink(destination: IndexView(), tag: .home, selection: $selectedTab) {
                Label("Home", systemImage: "house")
            }

            NavigationLink(destination: SearchView(), tag: .search, selection: $selectedTab) {
                Label("Search", systemImage: "magnifyingglass")
            }
            
            NavigationLink(destination: PlaylistsView(), tag: .playlists, selection: $selectedTab) {
                Label("Playlists", systemImage: "music.note.list")
            }
            
            NavigationLink(destination: MyMusicView(), tag: .myMusic, selection: $selectedTab) {
                Label("My Music", systemImage: "music.note.house")
            }

            NavigationLink(destination: SettingsView(), tag: .settings, selection: $selectedTab) {
                Label("Settings", systemImage: "gear")
            }
        }
        .listStyle(SidebarListStyle())
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top == 0 ? 15 : UIApplication.shared.windows.first?.safeAreaInsets.top)
        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 15 : UIApplication.shared.windows.first?.safeAreaInsets.bottom)
        .background(Color.firstBackground)
        .edgesIgnoringSafeArea(.all)
        
    }
}

struct Sidebar_Previews: PreviewProvider {
    @StateObject static var settings = SettingsViewModel()

    static var previews: some View {
        Sidebar()
            .environmentObject(settings)
            .colorScheme(settings.isDark ? .dark : .light)
    }
}
