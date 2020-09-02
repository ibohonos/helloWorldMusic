//
//  TabbarItem.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 20.08.2020.
//

import SwiftUI

struct TabbarItem: View {
    @Binding var selectedTab: Tabs?
    var image: String
    var tab: Tabs
    
    var body: some View {
        Button(action: { selectedTab = tab }, label: {
            Image(systemName: image)
        })
        .font(.system(size: 20))
        .foregroundColor(selectedTab == tab ? .white : .tabItemColor)
        .padding()
        .background(Color.accentColor.opacity(selectedTab == tab ? 1 : 0))
        .clipShape(Circle())
    }
}

struct TabbarItem_Previews: PreviewProvider {
    static var previews: some View {
        TabbarItem(selectedTab: .constant(.home), image: "house", tab: .home)
    }
}
