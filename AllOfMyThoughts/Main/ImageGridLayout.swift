import SwiftUI

struct ImageGridLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let proposal = proposal.replacingUnspecifiedDimensions()
        
        if (subviews.count == 1) {
            let size = subviews[0].sizeThatFits(.init(proposal))
            return .init(width: proposal.width, height: min(size.height, proposal.height))
        }
        return .init(width: 350, height: 350)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        if subviews.count == 0 {
            return
        }
        
        if subviews.count == 1 {
            let subview = subviews[0]
            subview.place(at: bounds.origin,
                          proposal: .init(bounds.size))
        } else if subviews.count == 2 {
            let width = bounds.width / 2
            var x: CGFloat = bounds.minX
            
            for (_, subview) in subviews.enumerated() {
                subview.place(at: .init(x: x, y: bounds.minY),
                              proposal: .init(width: width, height: bounds.height))
                x += width
            }
        } else if subviews.count == 3 {
            var height = bounds.height
            let width = bounds.width / 2
            var x: CGFloat = bounds.minX
            var y: CGFloat = bounds.minY
            
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
                var y: CGFloat = bounds.minY
                
                if index == 0 || index == 2 {
                    x = bounds.minX
                } else {
                    x = bounds.minX + width
                }
                
                if index >= 2 {
                    y = bounds.minY + height
                }
                
                subview.place(at: .init(x: x, y: y),
                              proposal: .init(width: width, height: height))
            }
        }
    }
}
