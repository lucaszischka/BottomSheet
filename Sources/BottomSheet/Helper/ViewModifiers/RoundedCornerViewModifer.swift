//
//  RoundedCornerViewModifer.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

#if os(macOS)
internal struct UIRectCorner: OptionSet {
    
    let rawValue: Int
    
    static let topLeft = UIRectCorner(
        rawValue: 1 << 0
    )
    static let topRight = UIRectCorner(
        rawValue: 1 << 1
    )
    static let bottomRight = UIRectCorner(
        rawValue: 1 << 2
    )
    static let bottomLeft = UIRectCorner(
        rawValue: 1 << 3
    )
    
    static let allCorners: UIRectCorner = [
        .topLeft,
        .topRight,
        .bottomLeft,
        .bottomRight
    ]
}

private struct RoundedCorner: Shape {
    
    var radius: CGFloat = .zero
    var corners: UIRectCorner = .allCorners
    
    func path(
        in rect: CGRect
    ) -> Path {
        var path = Path()
        
        let point1 = CGPoint(
            x: rect.minX,
            y: corners.contains(
                .topLeft
            ) ? rect.minY + radius  : rect.minY
        )
        let point2 = CGPoint(
            x: corners.contains(
                .topLeft
            ) ? rect.minX + radius : rect.minX,
            y: rect.minY
        )
        let point3 = CGPoint(
            x: corners.contains(
                .topRight
            ) ? rect.maxX - radius : rect.maxX,
            y: rect.minY
        )
        let point4 = CGPoint(
            x: rect.maxX,
            y: corners.contains(
                .topRight
            ) ? rect.minY + radius  : rect.minY
        )
        let point5 = CGPoint(
            x: rect.maxX,
            y: corners.contains(
                .bottomRight
            ) ? rect.maxY - radius : rect.maxY
        )
        let point6 = CGPoint(
            x: corners.contains(
                .bottomRight
            ) ? rect.maxX - radius : rect.maxX,
            y: rect.maxY
        )
        let point7 = CGPoint(
            x: corners.contains(
                .bottomLeft
            ) ? rect.minX + radius : rect.minX,
            y: rect.maxY
        )
        let point8 = CGPoint(
            x: rect.minX,
            y: corners.contains(
                .bottomLeft
            ) ? rect.maxY - radius : rect.maxY
        )
        
        path.move(
            to: point1
        )
        path.addArc(
            tangent1End: CGPoint(
                x: rect.minX,
                y: rect.minY
            ),
            tangent2End: point2,
            radius: radius
        )
        path.addLine(
            to: point3
        )
        path.addArc(
            tangent1End: CGPoint(
                x: rect.maxX,
                y: rect.minY
            ),
            tangent2End: point4,
            radius: radius
        )
        path.addLine(
            to: point5
        )
        path.addArc(
            tangent1End: CGPoint(
                x: rect.maxX,
                y: rect.maxY
            ),
            tangent2End: point6,
            radius: radius
        )
        path.addLine(
            to: point7
        )
        path.addArc(
            tangent1End: CGPoint(
                x: rect.minX,
                y: rect.maxY
            ),
            tangent2End: point8,
            radius: radius
        )
        path.closeSubpath()
        
        return path
    }
}
#else
private struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(
        in rect: CGRect
    ) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(
                width: radius,
                height: radius
            )
        )
        return Path(
            path.cgPath
        )
    }
}
#endif

internal extension View {
    func cornerRadius(
        _ radius: CGFloat,
        corners: UIRectCorner
    ) -> some View {
        clipShape(
            RoundedCorner(
                radius: radius,
                corners: corners
            )
        )
    }
}
