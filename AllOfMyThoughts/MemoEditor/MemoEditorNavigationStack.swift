import PhotosUI
import SwiftUI
import SwiftData
import UIKit

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
