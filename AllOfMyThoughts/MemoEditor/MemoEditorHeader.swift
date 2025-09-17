//
//  MemoEditorHeader.swift
//  AllOfMyThoughts
//
//  Created by iain on 02/09/2025.
//

import SwiftUI

struct MemoEditorHeader: View {
    let closeAction: () -> Void
    let postAction: () -> Void
    
    var body: some View {
        HStack {
            Button(action: {
//                visible = false
                closeAction()
            }, label: {
                Image(systemName: "x.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(8)
            })
            .padding(.leading, 8)
            
            Spacer()
            
            Text("New Post")
                .font(.custom(FontNames.DINAlternate_Bold.rawValue,
                              size: 24, relativeTo: .title))
            
            Spacer()
            
            Button(action: {
                postAction()
            }, label: {
                Image(systemName: "paperplane.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(8)
            })
            .padding(.trailing, 8)
        }
        .frame(height: 60, alignment: .leading)
        .background(Rectangle()                .fill(Color.secondary))
    }
}

#Preview {
    MemoEditorHeader(closeAction: {}, postAction: {})
}
