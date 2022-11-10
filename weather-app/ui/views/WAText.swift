//
//  WAText.swift
//  weather-app
//
//  Created by Rony on 10/11/22.
//

import SwiftUI

struct WAText: View {
    var text: String
    var fontSize: CGFloat
    var color: Color
    var weight: Font.Weight
    var design: Font.Design
    var alignment: TextAlignment
    @State var paddingLength: CGFloat = 0
    
    init(_ text: String,
         fontSize: CGFloat = 16,
         color: Color = .white,
         weight: Font.Weight = .medium,
         design: Font.Design = .default,
         alignment: TextAlignment = .center) {
        self.text = text
        self.fontSize = fontSize
        self.color = color
        self.weight = weight
        self.design = design
        self.alignment = alignment
    }
    
    var body: some View {
        Text(self.text)
            .font(.system(size: self.fontSize, weight: self.weight, design: self.design))
            .foregroundColor(self.color)
            .padding(self.paddingLength)
            .multilineTextAlignment(self.alignment)
    }
    
    func padding(_ length: CGFloat) {
        self.paddingLength = length
    }
}

struct WAText_Previews: PreviewProvider {
    static var previews: some View {
        WAText("")
    }
}
