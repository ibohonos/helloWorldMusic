//
//  BackgroundGradient.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 15.07.2020.
//

import SwiftUI

struct BackgroundGradient: View {
    var body: some View {
        GeometryReader {geo in
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [.gradientFirstColor, .gradientSecondColor]), startPoint: .init(x: 0.25, y: 0.5), endPoint: .init(x: 0.75, y: 0.5)))
                .frame(width: geo.size.width * 2, height: geo.size.height * 2)
                .position(x: geo.size.width, y: geo.size.height / 2)
//                .rotationEffect(.degrees(45), anchor: .center)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct BackgroundGradient_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundGradient()
            .environment(\.colorScheme, .dark)
    }
}
