//
//  ArtistCell.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 15.07.2020.
//

import SwiftUI

struct ArtistCell: View {
    var artist: TopArtists

    var body: some View {
        NavigationLink(destination: PlaylistView(.artists, artist: artist)) {
            VStack {
                Image(artist.image)
                    .renderingMode(.original)
                    .resizable()
                    .clipShape(ContainerRelativeShape())
                    .frame(width: 160, height: 160)
                    .scaledToFit()
                    .clipShape(CSShape(size: 15))
                    
                Text(artist.name)
                    .frame(width: 160)
            }
            .padding()
        }
    }
}

struct ArtistCell_Previews: PreviewProvider {
    static var previews: some View {
        ArtistCell(artist: TopArtists(name: "Taylor Swift", image: "Taylor_Swift"))
    }
}
