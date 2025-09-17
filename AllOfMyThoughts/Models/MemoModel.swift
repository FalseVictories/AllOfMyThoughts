//
//  Item.swift
//  AllOfMyThoughts
//
//  Created by iain on 26/08/2025.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class MemoModel {
    var timestamp: Date = Date.now
    var encryptedMemo: String = ""
    
    @Relationship(deleteRule: .cascade, inverse: \ImageModel.entry)
    var images: [ImageModel]
    
    @Relationship(deleteRule:. cascade, inverse: \LinkModel.entry)
    var links: [LinkModel]
    
    init(timestamp: Date,
         encryptedMemo: String,
         images: [ImageModel],
         links: [LinkModel]) {
        self.timestamp = timestamp
        self.encryptedMemo = encryptedMemo
        self.images = images
        self.links = links
    }
    
    func imagesFromData() -> [Image] {
        var i:[Image] = []
        for imageModel in images {
            if let uiImage = UIImage(data: imageModel.data) {
                i.append(Image(uiImage: uiImage))
            }
        }
        
        return i
    }
}
