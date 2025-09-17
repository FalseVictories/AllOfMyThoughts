import SwiftUI
import PhotosUI

struct MemoEditorImageStrip: View {
    let images: [Image]
    
    var body: some View {
        HStack {
            ForEach(0..<images.count, id: \.self) { i in
                images[i]
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}

#Preview {
    MemoEditorImageStrip(images: [])
}
