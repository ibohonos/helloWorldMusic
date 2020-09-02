//
//  AppleErrors.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 15.07.2020.
//

import Foundation

// MARK: - AppleErrors
struct AppleErrors: Codable {
    let errors: [AppleError]
}

// MARK: - AppleError
struct AppleError: Codable, Identifiable {
    let id, title, detail, status: String
    let code: String
}
