//
//  CustomSlider.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 20.08.2020.
//

import SwiftUI

struct CustomSlider<Component: View>: View {
    @Binding var value: Double
    var range: (Double, Double)
    var knobWidth: CGFloat?
    var viewBuilder: (CustomSliderComponents) -> Component
    var sliderChangeHandler: (Double) -> Void
    
    init(value: Binding<Double>,
         range: (Double, Double),
         knobWidth: CGFloat? = 0,
         sliderChangeHandler: @escaping (Double) -> Void,
         @ViewBuilder viewBuilder: @escaping (CustomSliderComponents) -> Component
    ) {
        _value = value
        self.range = range
        self.knobWidth = knobWidth
        self.sliderChangeHandler = sliderChangeHandler
        self.viewBuilder = viewBuilder
    }
    
    private func onDragChange(_ drag: DragGesture.Value, _ frame: CGRect) {
        let width = (knob: Double(knobWidth ?? frame.size.height), view: Double(frame.size.width))
        let xrange = (min: Double(0), max: Double(width.view - width.knob))
        var value = Double(drag.startLocation.x + drag.translation.width) // knob center x

        value -= 0.5*width.knob // offset from center to leading edge of knob
        value = value > xrange.max ? xrange.max : value // limit to leading edge
        value = value < xrange.min ? xrange.min : value // limit to trailing edge
        value = value.convert(fromRange: (xrange.min, xrange.max), toRange: range)

        withAnimation(.spring()) {
            self.value = value
        }

        sliderChangeHandler(value)
    }
    
    private func getOffsetX(frame: CGRect) -> CGFloat {
        let width = (knob: knobWidth ?? frame.size.height, view: frame.size.width)
        let xrange: (Double, Double) = (0, Double(width.view - width.knob))
        let result = value.convert(fromRange: range, toRange: xrange)

        return CGFloat(result)
    }
    
    var body: some View {
        GeometryReader { geometry in
            view(geometry: geometry)
        }
    }
    
    private func view(geometry: GeometryProxy) -> some View {
        let frame = geometry.frame(in: .global)
        let drag = DragGesture(minimumDistance: 0).onChanged({ drag in
            onDragChange(drag, frame)
        })
        
        let offsetX = getOffsetX(frame: frame)
        let knobSize = CGSize(width: knobWidth ?? frame.height, height: frame.height)
        let barLeftSize = CGSize(width: CGFloat(offsetX + knobSize.width * 0.5), height:  frame.height)
        let barRightSize = CGSize(width: frame.width - barLeftSize.width, height: frame.height)
        
        let modifiers = CustomSliderComponents(
            barLeft: CustomSliderModifier(name: .barLeft, size: barLeftSize, offset: 0),
            barRight: CustomSliderModifier(name: .barRight, size: barRightSize, offset: barLeftSize.width),
            knob: CustomSliderModifier(name: .knob, size: knobSize, offset: offsetX)
        )
        
        return ZStack {
            viewBuilder(modifiers)
                .gesture(drag)
        }
    }
}

struct CustomSlider_Previews: PreviewProvider {
    @State static var value: Double = 20

    static var previews: some View {
        CustomSlider(value: $value, range: (0, 100), knobWidth: 4, sliderChangeHandler: { _ in }) { modifiers in
            ZStack {
                Group {
                    Color(red: 0.4, green: 0.3, blue: 1)
                        .opacity(0.4)
                        .modifier(modifiers.barRight)
                    
                    Color(red: 0.4, green: 0.3, blue: 1)
                        .modifier(modifiers.barLeft)
                    
                }
                .cornerRadius(5)
                
                Image(systemName: "arrowtriangle.down.fill") // SF Symbol
                    .foregroundColor(.accentColor)
                    .offset(y: -5)
                    .modifier(modifiers.knob)
            }
        }
        .frame(height: 20)
        .padding(.horizontal)
    }
}
