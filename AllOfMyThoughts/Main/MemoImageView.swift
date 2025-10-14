import SwiftUI

struct MemoImageView: View {
    let images: [Image]
    let showImage: (Image) -> Void
    
    var body: some View {
        ImageGridLayout {
            ForEach(0..<images.count, id: \.self) { i in
                images[i]
                    .resizable()
                    .scaledToFill()
                    .onTapGesture {
                        showImage(images[i])
                    }
            }
        }
        .clipped()
    }
}

#Preview("1 image"){
    MemoImageView(images:[Image(.testimage)]) { _ in
        print("Click")
    }
    .frame(width: 350, height: 350)
}

#Preview("2 image") {
    MemoImageView(images: [Image(.testimage),
                           Image(.testimage2)]) { _ in
        print("Click")
    }
    .frame(width: 350, height: 350)
}

#Preview("3 image") {
    MemoImageView(images:[Image(.testimage),
                          Image(.testimage2),
                          Image(.testimage3)]) { _ in
        print("Click")
    }
    .frame(width: 350, height: 350)
}

#Preview("4 image") {
    MemoImageView(images:[Image(.testimage),
                          Image(.testimage2),
                          Image(.testimage3),
                          Image(.testimage4)]) { _ in
        print("Click")
    }
    .frame(width: 350, height: 350)
}
