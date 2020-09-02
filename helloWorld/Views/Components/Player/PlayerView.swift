//
//  PlayerView.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 13.08.2020.
//

import SwiftUI

struct PlayerView: View {
    @Namespace private var animation
    @EnvironmentObject private var player: PlayerViewModel
    
    var body: some View {
        Group {
            if player.isCollapsed {
                CollapsedPlayerView(animation: animation)
                    .frame(height: 86)
                    .background(Color.firstBackground)
                    .padding(.bottom, 66)
                    .onTapGesture(count: 1, perform: {
                        withAnimation(.easeIn) {
                            player.isCollapsed.toggle()
                        }
                    })
            } else {
                FullPlayerView(animation: animation)
                    .colorScheme(.dark)
                    .background(BackgroundGradient())
            }
        }
        .alert(isPresented: $player.showError) { player.errorMessage }
    }
}

struct PlayerView_Previews: PreviewProvider {
    @StateObject static var player = PlayerViewModel()
    static var previews: some View {
        PlayerView()
            .environmentObject(player)
    }
}
