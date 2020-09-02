//
//  SelectedView.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 14.07.2020.
//

import SwiftUI

struct SelectedView: View {
    @Binding var selectedTab: Tabs?

    @ViewBuilder var body: some View {
        switch selectedTab {
            case .home:
                IndexView()
            case .search:
                SearchView()
            case .playlists:
                PlaylistsView()
            case .myMusic:
                MyMusicView()
            case .settings:
                SettingsView()
            case .none:
                EmptyView()
        }
    }
}

struct SelectedView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedView(selectedTab: .constant(.home))
            .environmentObject(SettingsViewModel())
    }
}
