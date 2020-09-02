//
//  SettingsView.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 08.07.2020.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settings: SettingsViewModel

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

            List {
                Toggle("Dark mode", isOn: $settings.isDark)
                    .listRowBackground(Color.clear)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(SettingsViewModel())
    }
}
