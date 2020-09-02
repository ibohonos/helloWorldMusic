//
//  ContentView.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 30.06.2020.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            GeometryReader {geo in
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [.gradientFirstColor, .gradientSecondColor]), startPoint: .init(x: 0.25, y: 0.5), endPoint: .init(x: 0.75, y: 0.5)))
                    .frame(width: geo.size.width * 3, height: geo.size.height * 3)
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                    .rotationEffect(.degrees(45), anchor: .center)
            }

            HomeView()
//            Text("hello world")
        }
        .foregroundColor(.firstText)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
