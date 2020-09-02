//
//  PlaylistCell.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 15.07.2020.
//

import SwiftUI

struct PlaylistCell: View {
    var playlist: PlaylistDatum
    var cache: ImageCache

    var body: some View {
        NavigationLink(destination: PlaylistView(.playlist, playlist: playlist)) {
            VStack {
                if let url = playlist.attributes?.artwork.url,
                   let newURL = url.replacingOccurrences(of: "{w}", with: "\(240)").replacingOccurrences(of: "{h}", with: "\(240)") {
                    AsyncImage(url: URL(string: newURL)!, placeholder: Image(systemName: "photo"), cache: cache) { $0.renderingMode(.original).resizable() }
                        .frame(width: 160, height: 160)
                        .aspectRatio(contentMode: .fit)
                        .mask(ContainerRelativeShape())
                        .clipShape(CSShape(size: 15))
                }
                Text(playlist.attributes?.name ?? "")
                    .frame(width: 160)
            }
            .padding()
        }
    }
}

struct PlaylistCell_Previews: PreviewProvider {
    @Environment(\.imageCache) static var cache: ImageCache

    static var previews: some View {
        PlaylistCell(playlist: PlaylistDatum(id: "", type: "", href: "", attributes: nil), cache: cache)
    }
}
