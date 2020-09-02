//
//  helloWorldApp.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 30.06.2020.
//

import SwiftUI

@main
struct helloWorldApp: App {
    @StateObject var settings = SettingsViewModel()
    @StateObject var player = PlayerViewModel()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(settings)
                .environmentObject(player)
                .colorScheme(settings.isDark ? .dark : .light)
                .onAppear {
                    UITableViewCell.appearance().backgroundColor = .clear
                    UITableView.appearance().backgroundColor = .clear
//                    UITableViewHeaderFooterView.appearance().backgroundConfiguration = .clear()
                }
        }
    }
}
