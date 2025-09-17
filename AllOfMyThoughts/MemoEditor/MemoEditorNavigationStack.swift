import PhotosUI
import OpenGraph
import SwiftUI
import SwiftData
import UIKit

class LinkDetails {
    let url: URL
    var needsDetails: Bool = true
    
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
        guard needsDetails else {
            return
        }
        
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
        
        needsDetails = false
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
            
            addedLinks = linkDetails
        }
    }
    
    var imageData: [Data] = []
    var selectedImages: [Image] = []
    var addedLinks: [LinkDetails] = []
    
    func storeMemo(modelContext: ModelContext) async throws {
        var images = [ImageModel]()
        var links = [LinkModel]()
        
        for data in imageData {
            images.append(ImageModel(data: data))
        }
        
        for details in addedLinks {
            if !details.needsDetails {
                links.append(LinkModel(data: details.imageData,
                                       title: details.title,
                                       blurb: details.description,
                                       url: details.url))
            } else {
                try await details.load()
            }
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

struct MemoEditorNavigationStack: View {
    @Environment(\.modelContext) var modelContext

    @Binding var visible: Bool
    @Binding var sheetHeight: CGFloat
    
    @State var model = MemoEditorModel()
    
    var body: some View {
        NavigationStack {
            MemoEditorView(visible: $visible, model: model)
            .overlay {
                // Track the height of the editor to set the sheet
                // height correctly
                GeometryReader { geometry in
                    Color.clear.preference(key: InnerHeightPreferenceKey.self,
                                           value: geometry.size.height)
                }
            }
            .onPreferenceChange(InnerHeightPreferenceKey.self) {
                sheetHeight = $0
            }
            .navigationTitle("New Thought")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        visible = false
                    } label: {
                        Image(systemName: "x.circle")
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        Task {
                            try await model.storeMemo(modelContext: modelContext)
                        }
                        visible = false
                    } label: {
                        Image(systemName: "paperplane")
                    }
                }
            }
        }
    }
}

struct InnerHeightPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    MemoEditorNavigationStack(visible: .constant(true),
                              sheetHeight: .constant(100))
}
