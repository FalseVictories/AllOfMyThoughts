//
//  HeaderView.swift
//  AllOfMyThoughts
//
//  Created by iain on 04/09/2025.
//

import SwiftUI

struct HeaderView: View {
    let headerHeight: CGFloat
    
    var body: some View {
        GeometryReader() { geo in
            Text("The stars are the neon lights shining through the dancefloor of heaven on a Saturday night")
                .font(.custom(FontNames.DINAlternate_Bold.rawValue,
                              size: 11,
                              relativeTo: .caption))
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .opacity(0.8)
                .frame(width: geo.size.width / 2)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 8))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .background(alignment: .top) {
                    Image(.header)
                        .resizable()
                        .scaledToFill()
                        .frame(height: headerHeight, alignment: .center)
                        .clipped()
                        .overlay {
                            Rectangle().fill(LinearGradient(gradient: Gradient(colors: [.black.opacity(0.3), .clear]), startPoint: .leading, endPoint: .trailing))
                        }
                }
        }
    }
}

#Preview {
    HeaderView(headerHeight: 150)
        .frame(width: 340, height: 150)
}
