//
//  WAFittedSystemImage.swift
//  weather-app
//
//  Created by Rony on 10/11/22.
//

import SwiftUI

struct WAFittedSystemImage: View {
    var systemImageName: String
    var height: CGFloat?
    var width: CGFloat?
    var renderingMode: SymbolRenderingMode?
    
    init(systemImageName: String, height: CGFloat? = nil, width: CGFloat? = nil, renderingMode: SymbolRenderingMode = .monochrome) {
        self.systemImageName = systemImageName
        self.height = height
        self.width = width
        self.renderingMode = renderingMode
    }
    
    var body: some View {
        Image(systemName: self.systemImageName)
            .resizable()
            .scaledToFit()
            .frame(width: self.width, height: self.height)
            .symbolRenderingMode(self.renderingMode)
    }
}

struct WAFittedSystemImage_Previews: PreviewProvider {
    static var previews: some View {
        WAFittedSystemImage(systemImageName: "")
    }
}
