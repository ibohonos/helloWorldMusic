//
//  YouTubeSearch.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 17.07.2020.
//

import Foundation

// MARK: - YouTubeSearch
struct YouTubeSearch: Codable {
    let kind, etag, nextPageToken: String?
    let regionCode: String?
    let pageInfo: PageInfo?
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let kind, etag: String
    let id: MultipleTypes
    let snippet: Snippet
}

enum MultipleTypes: Codable {
    case string(String)
    case innerItem(ID)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(ID.self) {
            self = .innerItem(x)
            return
        }
        throw DecodingError.typeMismatch(MultipleTypes.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for MyValue"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let x):
            try container.encode(x)
        case .innerItem(let x):
            try container.encode(x)
        }
    }
}

// MARK: - ID
struct ID: Codable {
    let kind: String
    let videoID: String?
    let playlistID: String?

    enum CodingKeys: String, CodingKey {
        case kind
        case videoID = "videoId"
        case playlistID = "playlistId"
    }
}

// MARK: - Snippet
struct Snippet: Codable {
    let publishedAt, channelID, title, snippetDescription: String
    let thumbnails: Thumbnails
    let channelTitle: String
    let liveBroadcastContent, playlistID: String?
    let position: Int?
    let resourceID: ResourceID?

    enum CodingKeys: String, CodingKey {
        case publishedAt
        case channelID = "channelId"
        case playlistID = "playlistId"
        case resourceID = "resourceId"
        case title, position
        case snippetDescription = "description"
        case thumbnails, channelTitle, liveBroadcastContent
    }
}

// MARK: - ResourceID
struct ResourceID: Codable {
    let kind: String
    let videoID: String
    
    enum CodingKeys: String, CodingKey {
        case kind
        case videoID = "videoId"
    }
}

// MARK: - Thumbnails
struct Thumbnails: Codable {
    let thumbnailsDefault, medium, high: Default

    enum CodingKeys: String, CodingKey {
        case thumbnailsDefault = "default"
        case medium, high
    }
}

// MARK: - Default
struct Default: Codable {
    let url: String
    let width, height: Int
}

// MARK: - PageInfo
struct PageInfo: Codable {
    let totalResults, resultsPerPage: Int
}

#if DEBUG
let YouTubeSearchDebug = YouTubeSearch(kind: nil, etag: nil, nextPageToken: nil, regionCode: nil, pageInfo: nil, items: [])
#endif
