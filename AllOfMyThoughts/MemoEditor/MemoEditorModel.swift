import SwiftData
import SwiftUI

import OpenGraph

class LinkDetails {
    let url: URL
    
    var title: String?
    var imageData: Data? {
        didSet {
            if let imageData {
                image = Image(uiImage: UIImage(data: imageData)!)
            }
        }
    }
    var description: String?
    var image: Image?
    
    init(url: URL) {
        self.url = url
    }
    
    func load() async throws {
        let og = try await OpenGraph.fetch(url: url)
        
        if let image = og[.image] {
            if let imageURL = URL(string: image) {
                let (data, _) = try await URLSession.shared.data(from: imageURL)
                imageData = data
            }
        } else {
            imageData = nil
        }
        
        title = og[.title]
        description = og[.description]
    }
}

@Observable
class MemoEditorModel {
    var text: String = "" {
        didSet {
            let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matches = detector.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
            
            var linkDetails: [LinkDetails] = []
            for match in matches {
                if let url = match.url {
                    let details = LinkDetails(url: url)
                    linkDetails.append(details)
                }
            }

            addedLink = linkDetails.isEmpty ? nil : linkDetails[0]
        }
    }
    
    var imageData: [Data] = []
    var selectedImages: [Image] = []
    var addedLink: LinkDetails?
    
    func storeMemo(modelContext: ModelContext) async throws {
        var images = [ImageModel]()
        var links = [LinkModel]()
        
        for data in imageData {
            images.append(ImageModel(data: data))
        }
        
        if let addedLink {
            try await addedLink.load()
            links.append(LinkModel(data: addedLink.imageData,
                                   title: addedLink.title,
                                   blurb: addedLink.description,
                                   url: addedLink.url))
        }
        
        let memo = MemoModel(timestamp: .now,
                             encryptedMemo: text,
                             images: images,
                             links: links)
        withAnimation {
            modelContext.insert(memo)
        }
    }
}
