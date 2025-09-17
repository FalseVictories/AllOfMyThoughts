import SwiftUI

struct FullScreenImageView: View {
    let image: Image
    
    @Binding var isPresented: Bool
    @State private var fullsize: Bool = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            GeometryReader { geo in
                ScrollView([.horizontal, .vertical], showsIndicators: false) {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: fullsize ? nil : geo.size.width)
                    .onTapGesture(count: 2) {
                        withAnimation {
                            fullsize.toggle()
                        }
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .background(Color.black)
            }

            Button(action: {
                isPresented = false
            }, label: {
                Image(systemName: "x.circle.fill")
                    .resizable()
                    .foregroundStyle(.white)
            })
            .frame(width: 44, height: 44)
            .padding()
        }
    }
}

#Preview {
    FullScreenImageView(image: Image(.testimage2), isPresented: .constant(true))
}
