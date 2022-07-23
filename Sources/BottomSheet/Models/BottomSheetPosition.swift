//
//  BottomSheetPosition.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

public enum BottomSheetPosition: Equatable {
    /// The state where the BottomSheet is hidden
    case hidden
    
    /// The state where only the headerContent is visible
    case dynamicBottom
    
    /// The state where the height of the BottomSheet is equal to its content size
    /// Only makes sense for views that don't take all avaiable space (like ScrollVIew, Color, ...)
    case dynamic
    
    /// The state where only the headerContent is visible. The height of the BottomSheet is x%
    /// Only values between 0 and 1 make sense
    case relativeBottom(CGFloat)
    
    /// The state where the height of the BottomSheet is equal to x%
    /// Only values between 0 and 1 make sense
    case relative(CGFloat)
    
    /// The state where the height of the BottomSheet is equal to x%
    /// It funtions as top position for appleScrollBehaviour
    /// Only values between 0 and 1 make sense
    case relativeTop(CGFloat)
    
    ///  The state where only the headerContent is visible. The height of the BottomSheet is x
    /// Only values above 0 make sense
    case absoluteBottom(CGFloat)
    
    /// The state where the height of the BottomSheet is equal to x
    /// Only values above 0 make sense
    case absolute(CGFloat)
    
    /// The state where the height of the BottomSheet is equal to x
    /// It funtions as top position for appleScrollBehaviour
    /// Only values above 0 make sense
    case absoluteTop(CGFloat)
    
    internal var isHidden: Bool {
        switch self {
        case .hidden:
            return true
        default:
            return false
        }
    }
    
    internal var isBottom: Bool {
        switch self {
        case .dynamicBottom, .relativeBottom, .absoluteBottom:
            return true
        default:
            return false
        }
    }
    
    internal var isTop: Bool {
        switch self {
        case .relativeTop, .absoluteTop:
            return true
        default:
            return false
        }
    }
    
    internal var isDynamic: Bool {
        switch self {
        case .dynamic, .dynamicBottom:
            return true
        default:
            return false
        }
    }
    
    internal func asScreenHeight(
        with geometry: GeometryProxy
    ) -> CGFloat? {
        switch self {
        case .hidden:
            return 0
        case .dynamic, .dynamicBottom:
            return nil
        case .relative(let value), .relativeBottom(let value), .relativeTop(let value):
            return geometry.size.height * value
        case .absolute(let value), .absoluteBottom(let value), .absoluteTop(let value):
            return value
        }
    }
}
