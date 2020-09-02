//
//  SettingsViewModel.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 09.07.2020.
//

import Foundation
import SwiftUI


class SettingsViewModel: ObservableObject {
    @Published var isDark = getUserDark() {
        didSet {
            setUserDark(isDark)
        }
    }
}
