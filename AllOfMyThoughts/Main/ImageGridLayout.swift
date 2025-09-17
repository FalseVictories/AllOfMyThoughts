import SwiftUI

struct ImageGridLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        if subviews.count == 0 {
            return
        }
        
        if subviews.count == 1 {
            let subview = subviews[0]
            subview.place(at: .zero, anchor: .topLeading, proposal: .init(bounds.size))
        } else if subviews.count == 2 {
            let width = bounds.width / 2
            var x: CGFloat = 0
            
            for (_, subview) in subviews.enumerated() {
                subview.place(at: .init(x: x, y: 0), proposal: .init(width: width, height: bounds.height))
                x += width
            }
        } else if subviews.count == 3 {
            var height = bounds.height
            let width = bounds.width / 2
            var y: CGFloat = 0
            var x: CGFloat = 0
            
            for (index, subview) in subviews.enumerated() {
                subview.place(at: .init(x: x, y: y),
                              proposal: .init(width: width, height: height))
                if index == 0 {
                    height /= 2
                    x += width
                } else if index == 1 {
                    y += height
                }
            }
        } else if subviews.count == 4 {
            let width = bounds.width / 2
            let height = bounds.height / 2
            
            for (index, subview) in subviews.enumerated() {
                let x: CGFloat
                var y: CGFloat = 0
                
                if index == 0 || index == 2 {
                    x = 0
                } else {
                    x = width
                }
                
                if index >= 2 {
                    y = height
                }
                
                subview.place(at: .init(x: x, y: y),
                              anchor: .topLeading,
                              proposal: .init(width: width, height: height))
            }
        }
    }
}
