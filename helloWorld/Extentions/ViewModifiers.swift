//
//  ViewModifiers.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 14.08.2020.
//

import Foundation
import SwiftUI

struct CustomSliderModifier: ViewModifier {
    enum Name {
        case barLeft
        case barRight
        case knob
    }
    
    let name: Name
    let size: CGSize
    let offset: CGFloat

    func body(content: Content) -> some View {
        content
            .frame(width: size.width)
            .position(x: size.width*0.5, y: size.height*0.5)
            .offset(x: offset)
    }
}
