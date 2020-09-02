//
//  PlayerControls.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 25.08.2020.
//

import SwiftUI

struct PlayerControls: View {
    @EnvironmentObject private var player: PlayerViewModel
    
    var animation: Namespace.ID

    var body: some View {
        HStack {
            Button(action: { player.isShuffled.toggle() }) {
                Image(systemName: "shuffle")
                    .font(.title2)
                    .foregroundColor(player.isShuffled ? .accentColor : .firstText)
            }
            
            Spacer(minLength: 0)

            Button(action: { player.prevSong() }, label: {
                Image(systemName: "backward.end")
                    .font(.title2)
                    .foregroundColor(.firstText)
            })
            
            Spacer(minLength: 0)
            
            Button(action: { player.playPause() }) {
                Image(systemName: player.isPlayed ? "pause" : "play")
                    .font(.title2)
                    .foregroundColor(.firstText)
            }
            .padding([.vertical, .leading], player.isPlayed ? 0 : 14)
            .padding(.trailing, player.isPlayed ? 0 : 11)
            .padding(player.isPlayed ? 15 : 0)
            .frame(width: 60, height: 60, alignment: .center)
            .background(Color.accentColor)
            .clipShape(Circle())
            .matchedGeometryEffect(id: "playButton", in: animation)
            .environment(\.colorScheme, .dark)
            
            Spacer(minLength: 0)
            
            Button(action: { player.nextSoung() }, label: {
                Image(systemName: "forward.end")
                    .font(.title2)
                    .foregroundColor(.firstText)
            })
            .matchedGeometryEffect(id: "forwardButton", in: animation)
            
            Spacer(minLength: 0)
            
            Button(action: {
                switch player.repearType {
                    case .none:
                        player.repearType = .once
                    case .once:
                        player.repearType = .enabled
                    case .enabled:
                        player.repearType = .none
                }
            }) {
                Image(systemName: player.repearType == .once ? "repeat.1" : "repeat")
                    .font(.title2)
                    .foregroundColor(player.repearType == .none ? .firstText : .accentColor)
            }
        }
        .padding(.horizontal)
    }
}

struct PlayerControls_Previews: PreviewProvider {
    @Namespace static var animation

    static var previews: some View {
        PlayerControls(animation: animation)
    }
}
