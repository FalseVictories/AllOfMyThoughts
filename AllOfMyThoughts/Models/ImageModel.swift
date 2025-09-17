import Foundation
import SwiftData

@Model
class ImageModel {
    @Attribute(.externalStorage)
    var data: Data
    var entry: MemoModel?
    
    init(data: Data) {
        self.data = data
    }
}
