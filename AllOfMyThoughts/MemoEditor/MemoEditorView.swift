import PhotosUI
import OpenGraph
import SwiftUI
import SwiftData
import UIKit

struct MemoEditorView: View {
    @Binding var visible: Bool
    @Bindable var model: MemoEditorModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                PlaceholderTextEditor(placeholder: "What're you thinking?",
                                      text: $model.text)
                .font(.custom(FontNames.Avenir_Roman.rawValue,
                              size: 20,
                              relativeTo: .body))
                .frame(height: 256)
                
                MemoEditorToolbar(count: model.text.count,
                                  onAddImages: addImages)
                
                if !model.selectedImages.isEmpty {
                    MemoEditorImageStrip(images: model.selectedImages)
                        .frame(height: 100)
                }
                
                if let addedLink = model.addedLink {
                    HStack {
                        Image(systemName: "link.badge.plus")
                        Text(addedLink.url.absoluteString)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

extension MemoEditorView {
    func addImages(_ images: [PhotosPickerItem]) {
        model.selectedImages = []
        model.imageData = []
        
        Task {
            for item in images {
                if let data = try await item.loadTransferable(type: Data.self) {
                    model.imageData.append(data)
                    if let uiImage = UIImage(data: data) {
                        model.selectedImages.append(Image(uiImage: uiImage))
                    }
                }
            }
        }
    }
}

#Preview {
    MemoEditorView(visible: .constant(true), model: MemoEditorModel())
}
