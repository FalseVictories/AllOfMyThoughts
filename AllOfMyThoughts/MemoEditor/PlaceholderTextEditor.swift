//
//  PlaceholderTextEditor.swift
//  AllOfMyThoughts
//
//  Created by iain on 28/08/2025.
//

import SwiftUI

struct PlaceholderTextEditor: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        ZStack {
            TextEditor(text: $text)
            
            if text.isEmpty {
                VStack {
                    HStack {
                        Text(placeholder)
                            .foregroundStyle(.tertiary)
                            .padding(.top, 8)
                            .padding(.leading, 5)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    PlaceholderTextEditor(placeholder: "What're you thinking?",
                          text: .constant(""))
}
