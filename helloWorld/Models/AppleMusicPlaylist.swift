//
//  AppleMusicPlaylist.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 17.07.2020.
//

import Foundation

// MARK: - AppleMusicPlaylist
struct AppleMusicPlaylist: Codable {
    let data: [AppleMusicPlaylistDatum]
}

// MARK: - AppleMusicPlaylistDatum
struct AppleMusicPlaylistDatum: Codable {
    let id, type, href: String
    let attributes: PlaylistPurpleAttributes?
    let relationships: PlaylistRelationships
}

// MARK: - PlaylistPurpleAttributes
struct PlaylistPurpleAttributes: Codable {
    let artwork: Artwork
    let isChart: Bool
    let url: String
    let lastModifiedDate, name, playlistType, curatorName: String
    let playParams: PlayParams
    let attributesDescription: Description

    enum CodingKeys: String, CodingKey {
        case artwork, isChart, url, lastModifiedDate, name, playlistType, curatorName, playParams
        case attributesDescription = "description"
    }
}

// MARK: - Description
struct Description: Codable {
    let standard, short: String
}

// MARK: - PlaylistRelationships
struct PlaylistRelationships: Codable {
    let tracks, curator: Curator
}

// MARK: - Curator
struct Curator: Codable {
    let href: String
    let data: [CuratorDatum]
}

// MARK: - CuratorDatum
struct CuratorDatum: Codable {
    let id, type, href: String
    let attributes: PlaylistFluffyAttributes?
}

// MARK: - PlaylistFluffyAttributes
struct PlaylistFluffyAttributes: Codable {
    let previews: [Preview]
    let artwork: Artwork
    let artistName: String
    let url: String
    let discNumber: Int
    let genreNames: [String]
    let durationInMillis: Int
    let releaseDate: String?
    let name, isrc: String
    let hasLyrics: Bool
    let albumName: String
    let playParams: PlayParams
    let trackNumber: Int
    let composerName, contentRating: String?
}

#if DEBUG
let AppleMusicPlaylistDebug = AppleMusicPlaylist(data: [])
#endif
