//
//  CollapsedPlayerView.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 13.08.2020.
//

import SwiftUI

struct CollapsedPlayerView: View {
    @Environment(\.imageCache) var cache: ImageCache
    @EnvironmentObject private var player: PlayerViewModel
    
    var animation: Namespace.ID

    var body: some View {
        VStack(spacing: 0) {
            CustomSlider(value: $player.currentProgress, range: (0, player.duration), knobWidth: 9, sliderChangeHandler: { value in
                player.seek(value)
            }) { modifiers in
                ZStack {
                    Color.trackBackground
                        .frame(height: 3)
                        .modifier(modifiers.barLeft)
                    
                    ZStack {
                        Circle().fill(Color.accentColor)
                        Circle().stroke(Color.black.opacity(0.2), lineWidth: 2)
                    }
                    .frame(height: 9)
                    .modifier(modifiers.knob)
                }
            }
            .frame(height: 9)
            .padding(.top, -23)
            .matchedGeometryEffect(id: "timeSlider", in: animation)

            HStack(spacing: 20) {
                if player.isLoadImage {
                    ActivityIndicator(shouldAnimate: $player.isLoadImage)
                        .frame(width: 50, height: 50)
                } else {
                    AsyncImage(url: URL(string: player.song.snippet.thumbnails.medium.url)!, placeholder: Image(systemName: "photo"), cache: cache) { $0.resizable() }
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .matchedGeometryEffect(id: "playlistImage", in: animation)
                }

                VStack(alignment: .leading) {
                    Text(player.song.snippet.title)
                        .lineLimit(1)
                        .matchedGeometryEffect(id: "soungName", in: animation)
                        
                    Text(player.song.snippet.snippetDescription)
                        .lineLimit(1)
                        .matchedGeometryEffect(id: "artistName", in: animation)
                }
                
                Spacer(minLength: 0)
                
                Button(action: { player.playPause() }, label: {
                    Image(systemName: player.isPlayed ? "pause" : "play")
                        .font(.title2)
                        .foregroundColor(.firstText)
                })
                .padding([.vertical, .leading], player.isPlayed ? 0 : 15)
                .padding(.trailing, player.isPlayed ? 0 : 12)
                .padding(player.isPlayed ? 15 : 0)
                .frame(width: 48, height: 48, alignment: .center)
                .background(Color.accentColor)
                .clipShape(Circle())
                .matchedGeometryEffect(id: "playButton", in: animation)
                .environment(\.colorScheme, .dark)
                
                Button(action: { player.nextSoung() }, label: {
                    Image(systemName: "forward.end")
                        .font(.title2)
                        .foregroundColor(.firstText)
                })
                .matchedGeometryEffect(id: "forwardButton", in: animation)
                
            }
            .padding(.horizontal)
        }
        .matchedGeometryEffect(id: "player", in: animation)
    }
}

struct CollapsedPlayerView_Previews: PreviewProvider {
    @Namespace static var animation

    static var previews: some View {
        CollapsedPlayerView(animation: animation)
            .frame(height: 86)
            .background(Color.firstBackground)
            .environmentObject(PlayerViewModel())
            .environment(\.colorScheme, .dark)
    }
}
