//
//  MemoEditorToolbar.swift
//  AllOfMyThoughts
//
//  Created by iain on 02/09/2025.
//

import SwiftUI
import PhotosUI

struct MemoEditorToolbar: View {
    let count: Int
    let onAddImages: ([PhotosPickerItem]) -> Void

    @State private var selectedItems: [PhotosPickerItem] = []
    
    var body: some View {
        HStack(spacing: 16) {
            PhotosPicker(selection:$selectedItems,
                         maxSelectionCount: 4,
                         selectionBehavior: .continuous,
                         matching: .images) {
                Image(systemName: "photo.fill")
            }
                        
            Spacer()
            
            Text(count, format: .number.grouping(.automatic))
                .font(.custom(FontNames.DINAlternate_Bold.rawValue,
                              size: 14, relativeTo: .body))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .onChange(of: selectedItems) {
            onAddImages(selectedItems)
        }
    }
}

#Preview {
    MemoEditorToolbar(count: 1000) { images in
        print("Add images: \(images.count)")
    }
}
