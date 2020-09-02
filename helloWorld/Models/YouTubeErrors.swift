//
//  YouTubeErrors.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 15.07.2020.
//

import Foundation

// MARK: - YouTubeErrors
struct YouTubeErrors: Codable {
    let error: YouTubeErrorsError
}

// MARK: - YouTubeErrorsError
struct YouTubeErrorsError: Codable {
    let errors: [ErrorElement]
    let code: Int
    let message: String
}

// MARK: - ErrorElement
struct ErrorElement: Codable {
    let domain, reason, message, locationType: String?
    let location: String?
}
