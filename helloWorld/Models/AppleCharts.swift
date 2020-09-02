//
//  AppleCharts.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 15.07.2020.
//

import Foundation

// MARK: - AppleCharts
struct AppleCharts: Codable {
    let results: Results
}

// MARK: - Results
struct Results: Codable {
    let songs: [Song]?
    let albums: [Album]?
    let playlists: [ApplePlaylist]?
}

// MARK: - Album
struct Album: Codable {
    let name, chart, href: String
    let next: String?
    let data: [AlbumDatum]
}

// MARK: - AlbumDatum
struct AlbumDatum: Codable {
    let id: String
    let type: String
    let href: String
    let attributes: PurpleAttributes?
}

// MARK: - PurpleAttributes
struct PurpleAttributes: Codable {
    let artwork: Artwork
    let artistName: String
    let isSingle: Bool
    let url: String
    let isComplete: Bool
    let genreNames: [String]
    let trackCount: Int
    let isMasteredForItunes: Bool
    let name, recordLabel, copyright: String
    let releaseDate: String?
    let playParams: PlayParams
//    let editorialNotes: EditorialNotes?
    let isCompilation: Bool
    let contentRating: String?
}

// MARK: - Artwork
struct Artwork: Codable {
    let width, height: Int
    let url, bgColor, textColor1, textColor2: String?
    let textColor3, textColor4: String?
}

// MARK: - EditorialNotes
struct EditorialNotes: Codable {
    let standard, short: String
}

// MARK: - PlayParams
struct PlayParams: Codable {
    let id: String
    let kind: String
}

// MARK: - Playlist
struct ApplePlaylist: Codable {
    let name, chart, href: String
    let next: String?
    let data: [PlaylistDatum]
}

// MARK: - PlaylistDatum
struct PlaylistDatum: Codable, Equatable {
    let id: String
    let type: String
    let href: String
    let attributes: FluffyAttributes?
    
    static func == (lhs: PlaylistDatum, rhs: PlaylistDatum) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - FluffyAttributes
struct FluffyAttributes: Codable {
    let artwork: Artwork
    let isChart: Bool
    let url: String
    let lastModifiedDate: String
    let name: String
    let playlistType: String
    let curatorName: String
    let playParams: PlayParams
//    let description: EditorialNotes
}

// MARK: - Song
struct Song: Codable {
    let name, chart, href: String
    let next: String?
    let data: [SongDatum]
}

// MARK: - SongDatum
struct SongDatum: Codable {
    let id: String
    let type: String
    let href: String
    let attributes: TentacledAttributes
}

// MARK: - TentacledAttributes
struct TentacledAttributes: Codable {
    let previews: [Preview]
    let artwork: Artwork
    let artistName: String
    let url: String
    let discNumber: Int
    let genreNames: [String]
    let durationInMillis: Int
    let name, isrc: String
    let releaseDate: String?
    let hasLyrics: Bool
    let albumName: String
    let playParams: PlayParams
    let trackNumber: Int
    let composerName: String?
    let contentRating: String?
}

// MARK: - Preview
struct Preview: Codable {
    let url: String
}


#if DEBUG
var DebugPlaylist = PlaylistDatum(id: "pl.f4d106fed2bd41149aaacabb233eb5eb",
                                  type: "playlists",
                                  href: "/v1/catalog/us/playlists/pl.f4d106fed2bd41149aaacabb233eb5eb",
                                  attributes: FluffyAttributes(artwork: Artwork(width: 4320,
                                                                                height: 1080,
                                                                                url: "https://is3-ssl.mzstatic.com/image/thumb/Features114/v4/66/86/a4/6686a470-165d-ac61-eac1-eb08d61f3bdb/source/{w}x{h}cc.jpeg",
                                                                                bgColor: "7a5020",
                                                                                textColor1: "fff6e4",
                                                                                textColor2: "efebe9",
                                                                                textColor3: "e4d4bc",
                                                                                textColor4: "d7ccc1"
                                                               ),
                                                               isChart: false,
                                                               url: "https://music.apple.com/us/playlist/todays-hits/pl.f4d106fed2bd41149aaacabb233eb5eb",
                                                               lastModifiedDate: "2020-07-16T17:04:56Z",
                                                               name: "Today’s Hits",
                                                               playlistType: "editorial",
                                                               curatorName: "Apple Music Pop",
                                                               playParams: PlayParams(id: "pl.f4d106fed2bd41149aaacabb233eb5eb",
                                                                                      kind: "playlist"
                                                               )
                                  )
)
#endif
