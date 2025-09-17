import Foundation
import SwiftData
import SwiftUI

struct SimpleLinkModel {
    let image: Image?
    let title: String?
    let blurb: String?
    let url: URL
}

@Model
class LinkModel {
    @Attribute(.externalStorage)
    var data: Data?
    var title: String?
    var blurb: String?
    var url: URL
    
    var entry: MemoModel?
    
    init(data: Data?, title: String?, blurb: String?, url: URL) {
        self.data = data
        self.title = title
        self.blurb = blurb
        self.url = url
    }

    func toSimpleModel() -> SimpleLinkModel {
        var image: Image? = nil
        if let data, let uiImage = UIImage(data: data) {
            image = Image(uiImage: uiImage)
        }
        return SimpleLinkModel(image: image, title: title, blurb: blurb, url: url)
    }
}
