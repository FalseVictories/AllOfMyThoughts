import SwiftUI

struct LinkView: View {
    @Environment(\.openURL) var openURL
    
    let image: Image?
    let title: String
    let summary: String
    let url: URL
    
    var body: some View {
        VStack(alignment: .leading) {
            if let image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity,
                           maxHeight: 200)
                    .clipped()
            }
            
            Text(title)
                .font(.caption)
            Text(summary)
                .font(.footnote)
        }
        .padding()
        .onTapGesture {
            openURL(url, prefersInApp: true)
        }
    }
}

#Preview {
    LinkView(image: Image(.testimage4),
             title: "This is an example",
             summary: "This is a summary telling you about the link",
             url: URL(string: "https://www.google.com")!)
}
