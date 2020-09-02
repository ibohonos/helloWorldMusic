//
//  SearchView.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 14.07.2020.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    
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

            List {
                Text("Hello, World! Search")
                    .listRowBackground(Color.clear)
            }
        }
        .navigationBarSearch($searchText, onTitleView: true)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
