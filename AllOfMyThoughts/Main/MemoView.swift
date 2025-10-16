//
//  MemoView.swift
//  AllOfMyThoughts
//
//  Created by iain on 26/08/2025.
//

import DateToolsSwift
import Foundation
import SwiftUI

@Observable
class MemoController {
    var sheetImage: Image? {
        didSet {
            print("sheet has image: \(sheetImage != nil)")
            showSheet = sheetImage != nil
        }
    }
    
    var showSheet: Bool = false
}

public struct MemoView: View {
    @State private var controller = MemoController()
    let timestamp: Date
    let memo: String
    
    let images: [Image]
    let links: [SimpleLinkModel]
    
    var timestampString: String {
        if timestamp > 1.months.earlier {
            return timestamp.timeAgoSinceNow
        } else {
            return timestamp.format(with: .medium)
        }
    }
    
    public var body: some View {
        VStack {
            HStack {
                Image(systemName: "star")
                    .resizable()
                    .frame(width:32, height: 32)
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment:.center) {
                        Text("!a¡n")
                        //                        .font(.subheadline)
                            .fontWeight(.semibold)
                        Spacer()
                        Text(timestampString)
                        //                        .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .font(.custom(FontNames.DINAlternate_Bold.rawValue,
                                  size: 14,
                                  relativeTo: .caption))
                    
                    if !memo.isEmpty {
                        Text(memo)
                            .font(.custom(FontNames.Avenir_Roman.rawValue,
                                          size: 17, relativeTo: .body))
                    }
                }
            }
            .frame(alignment: .leading)
            
            if !images.isEmpty {
                MemoImageView(images: images) {
                    controller.sheetImage = $0
                }
                .frame(minHeight: 100, maxHeight: 350)
                .clipped()
            }
            
            if !links.isEmpty {
                LinkView(image: links[0].image,
                         title: links[0].title ?? "",
                         summary: links[0].blurb ?? "",
                         url: links[0].url)
            }
        }
        .sheet(isPresented: $controller.showSheet) {
            if let sheetImage = controller.sheetImage {
                FullScreenImageView(image: sheetImage,
                                    isPresented: $controller.showSheet)
            }
        }
    }
}

#Preview {
    MemoView(timestamp: .now,
             memo: "Techbrofash complaining that Europe does not contribute 5% of its gdp to military because they rely on U.S. military so much - but maybe it’s because they don’t feel that they’re constantly under threat of attack",
             images: [Image(.header)], links:[])
}
