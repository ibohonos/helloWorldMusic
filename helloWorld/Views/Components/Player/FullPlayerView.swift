//
//  FullPlayerView.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 13.08.2020.
//

import SwiftUI
import Sliders

struct FullPlayerView: View {
    @Environment(\.imageCache) var cache: ImageCache
    @EnvironmentObject private var player: PlayerViewModel

    var animation: Namespace.ID
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
            if player.isLoadImage {
                ActivityIndicator(shouldAnimate: $player.isLoadImage)
                    .frame(width: UIApplication.shared.windows.first?.screen.bounds.width, height: UIApplication.shared.windows.first?.screen.bounds.height)
            } else {
                AsyncImage(url: URL(string: player.song.snippet.thumbnails.medium.url)!, placeholder: Image(systemName: "photo"), cache: cache) { $0.resizable() }
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.top)
                    .frame(width: UIApplication.shared.windows.first?.screen.bounds.width, height: UIApplication.shared.windows.first?.screen.bounds.height)
                    .blur(radius: 150)
            }
            
            VStack {
                VStack(spacing: 15) {
                    Image(systemName: "chevron.down")
                        .resizable()
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .frame(width: 48, height: 16, alignment: .center)
                        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                        .onTapGesture(count: 1, perform: {
                            withAnimation(.easeOut) {
                                player.isCollapsed.toggle()
                            }
                        })

                    Spacer(minLength: 0)
                    
                    if player.isLoadImage {
                        ActivityIndicator(shouldAnimate: $player.isLoadImage)
                            .frame(height: 100)
                    } else {
                        AsyncImage(url: URL(string: player.song.snippet.thumbnails.medium.url)!, placeholder: Image(systemName: "photo"), cache: cache) { $0.resizable() }
                            .scaledToFit()
                            .cornerRadius(20)
                            .frame(height: 100)
                            .matchedGeometryEffect(id: "playlistImage", in: animation)
                    }

                    VStack {
                        Text(player.song.snippet.title)
                            .font(.title)
                            .lineLimit(1)
                            .matchedGeometryEffect(id: "soungName", in: animation)
                            
                        Text(player.song.snippet.snippetDescription)
                            .font(.title2)
                            .lineLimit(1)
                            .matchedGeometryEffect(id: "artistName", in: animation)
                    }

                    Spacer(minLength: 0)
                    
                    CustomSlider(value: $player.currentProgress, range: (0, player.duration), sliderChangeHandler: { value in
                        player.seek(value)
                    }) { modifiers in
                        ZStack {
                            Color.accentColor
                                .modifier(modifiers.barLeft)
                            Color.trackBackground
                                .modifier(modifiers.barRight)
                        }
                        .clipShape(MagnitudeChart(values: player.randomValues))
                    }
                    .padding(.horizontal)
                    .frame(height: 64)
                    .matchedGeometryEffect(id: "timeSlider", in: animation)
                    
                    HStack {
                        Text("\(Utility.formatSecondsToHMS(player.currentProgress))")
                        Spacer()
                        Text("\(Utility.formatSecondsToHMS(player.duration))")
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 0)
                    
                    PlayerControls(animation: animation)
                    
                    Spacer(minLength: 0)
                }
                .padding()
                
                Spacer()
                
                HStack {
                    Button(action: {}, label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title)
                            .foregroundColor(.firstText)
                    })
                    
                    Spacer(minLength: 0)
                    
                    Button(action: {}, label: {
                        Image(systemName: "list.bullet")
                            .font(.title)
                            .foregroundColor(.firstText)
                    })
                }
                .padding(30)
            }
        }
        .matchedGeometryEffect(id: "player", in: animation)
    }
}

struct FullPlayerView_Previews: PreviewProvider {
    @Namespace static var animation

    static var previews: some View {
        FullPlayerView(animation: animation)
            .environmentObject(PlayerViewModel())
    }
}
