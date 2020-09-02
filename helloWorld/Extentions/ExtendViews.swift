//
//  ExtendViews.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 07.07.2020.
//

import Foundation
import SwiftUI

extension Color {
    static let firstText = Color("FirstText")
    static let secondText = Color("SecondText")
    static let gradientFirstColor = Color("GradientFirstColor")
    static let gradientSecondColor = Color("GradientSecondColor")
    static let accentFirstGradient = Color("AccentFirstGradient")
    static let accentSecondGradient = Color("AccentSecondGradient")
    static let tabItemColor = Color("TabItemColor")
    static let firstBackground = Color("FirstBackground")
    static let trackBackground = Color("TrackBackground")
}

extension UIColor {
    static let firstText = UIColor(named: "FirstText")!
    static let secondText = UIColor(named: "SecondText")!
    static let gradientFirstColor = UIColor(named: "GradientFirstColor")!
    static let gradientSecondColor = UIColor(named: "GradientSecondColor")!
    static let accentFirstGradient = UIColor(named: "AccentFirstGradient")!
    static let accentSecondGradient = UIColor(named: "AccentSecondGradient")!
    static let tabItemColor = UIColor(named: "TabItemColor")!
    static let firstBackground = UIColor(named: "FirstBackground")!
    static let trackBackground = UIColor(named: "TrackBackground")!
}

extension View {
    func accentBackgroundGradient() -> some View {
        background(
            LinearGradient(
                gradient: Gradient(colors: [.accentFirstGradient, .accentSecondGradient]),
                startPoint: .init(x: 0.25, y: 0.5),
                endPoint: .init(x: 0.75, y: 0.5)
            )
        )
        .foregroundColor(.white)
    }
}

extension Double {
    func convert(fromRange: (Double, Double), toRange: (Double, Double)) -> Double {
        // Example: if self = 1, fromRange = (0,2), toRange = (10,12) -> solution = 11
        var value = self

        value -= fromRange.0
        value /= Double(fromRange.1 - fromRange.0)
        value *= toRange.1 - toRange.0
        value += toRange.0

        return value
    }
}
