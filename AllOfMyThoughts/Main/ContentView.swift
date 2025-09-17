import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [MemoModel]
    
    @State private var showAddMemo: Bool = false
    @State private var sheetHeight: CGFloat = 100
    
    @State private var headerHeight: CGFloat = 150
    @State var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    MemoView(timestamp: item.timestamp,
                             memo: item.encryptedMemo,
                             images: item.imagesFromData(),
                             links: item.links.map { $0.toSimpleModel() })
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                }
            }
            .searchable(text: $searchText)
            .toolbar {
                if #available(iOS 26.0, *) {
                    DefaultToolbarItem(kind: .search, placement: .bottomBar)
                    ToolbarSpacer(.flexible, placement: .bottomBar)
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Button { showAddMemo = true }
                    label: {
                        Image(systemName: "pencil")
                    }
                }
            }
            .padding(.top, 150)
            .overlay(alignment: .top) {
                HeaderView(headerHeight: headerHeight)
                    .frame(height: headerHeight, alignment: .bottomTrailing)
                    .clipped()
            }
            .scrollContentBackground(.hidden)
            .background(Gradient(colors: [.teal, .cyan, .green]).opacity(0.6))
            .listStyle(.plain)
            .ignoresSafeArea()
            .sheet(isPresented: $showAddMemo){
                MemoEditorNavigationStack(visible: $showAddMemo,
                                          sheetHeight: $sheetHeight)
                .presentationDetents([.height(sheetHeight + 90)])
            }
            .onScrollGeometryChange(for: CGFloat.self) { geo in
                return geo.contentOffset.y
            } action: { _, new in
                headerHeight = max(150 - new, 150)
            }
        }
    }
    
    private func addItem() {
        showAddMemo = true
    }
}

#Preview {
    ContentView()
        .modelContainer(for: MemoModel.self, inMemory: true)
}
