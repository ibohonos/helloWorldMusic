//
//  Shapes.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 13.08.2020.
//

import Foundation
import SwiftUI

struct CSShape: Shape {
    var size: CGFloat
    var corners: UIRectCorner = [.topLeft, .topRight]

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: size, height: size))
        
        return Path(path.cgPath)
    }
}

struct MagnitudeChart: Shape {
    var values: [CGFloat]

    func path(in rect: CGRect) -> Path {
        let maxValue = values.max() ?? 9
        let minValue = values.min() ?? 0
        var path = Path()

        path.move(to: rect.origin)

        for (index, value) in values.enumerated() {
            let padding = rect.height * (1 - value / (maxValue - minValue))
            let barWidth: CGFloat = 3
            let spacing = (rect.width - barWidth * CGFloat(values.count)) / CGFloat(values.count - 1)
            let barRect = CGRect(x: (CGFloat(barWidth) + spacing) * CGFloat(index),
                                 y: rect.origin.y + padding * 0.5,
                                 width: barWidth,
                                 height: rect.height - padding)

            path.addRoundedRect(in: barRect, cornerSize: CGSize(width: 1, height: 1))
        }

        let bounds = path.boundingRect
        let scaleX = rect.size.width/bounds.size.width
        let scaleY = rect.size.height/bounds.size.height

        return path.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
    }
}
