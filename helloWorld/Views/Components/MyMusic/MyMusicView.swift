//
//  MyMusicView.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 15.07.2020.
//

import SwiftUI

struct MyMusicView: View {
    var body: some View {
//        #if os(iOS)
//        if sizeClass == .compact {
            NavigationView {
                content
            }
            .navigationViewStyle(StackNavigationViewStyle())
//        } else {
//            content
//        }
//        #else
//            content
//        #endif
    }
    
    var content: some View {
        ZStack {
            BackgroundGradient()

            Text("Hello, World! My Music")
        }
        .navigationTitle("My Music")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MyMusicView_Previews: PreviewProvider {
    static var previews: some View {
        MyMusicView()
    }
}
