//
//  TopArtists.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 15.07.2020.
//

import Foundation

struct TopArtists: Codable, Identifiable, Equatable {
    var id = UUID()

    let name: String
    let image: String
}

#if DEBUG
var DebugArtists: [TopArtists] = [
    .init(name: "Billie Eilish", image: "Billie_Eilish"),
    .init(name: "Cardi B", image: "Cardi_B"),
    .init(name: "Imagine Dragons", image: "Imagine_Dragons"),
    .init(name: "Taylor Swift", image: "Taylor_Swift"),
    .init(name: "Jason Derulo", image: "Jason_Derulo"),
    .init(name: "Kety Perry", image: "Kety_Perry"),
    .init(name: "Shakira", image: "Shakira"),
    .init(name: "Ed Sheeran", image: "Ed_Sheeran"),
    .init(name: "Enrique Iglesias", image: "Enrique_Iglesias"),
    .init(name: "Selena Gomez", image: "Selena_Gomez")
]
#endif
