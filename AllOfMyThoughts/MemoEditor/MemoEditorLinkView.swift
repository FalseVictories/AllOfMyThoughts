//
//  MemoEditorLinkView.swift
//  AllOfMyThoughts
//
//  Created by iain on 10/09/2025.
//

import SwiftUI

struct MemoEditorLinkView: View {
    let url: URL
    let busy: Bool
    let image: Image?
    
    var body: some View {
        HStack {
            if busy {
                ProgressView()
            }
            
            if let image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 44)
            }
            
            Text(url.absoluteString)
        }
    }
}

#Preview {
    MemoEditorLinkView(url: URL(string: "http://falsevictories.com")!,
                       busy: true,
                       image: nil)
}

#Preview {
    MemoEditorLinkView(url: URL(string: "http://falsevictories.com")!,
                       busy: false,
                       image: Image(.testimage3))
}
