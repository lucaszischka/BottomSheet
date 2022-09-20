//
//  BottomSheetPosition.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

/// `BottomSheetPosition` defines the possible BottomSheet states you can switch into.
///
/// Currently there are three major types:
/// - `.dynamic...`, where the height of the BottomSheet is equal to its content height
/// - `.relative...`, where the height of the BottomSheet is a percentage of the screen height
/// - `.absolute...`, where the height of the BottomSheet is a pixel value
///
/// You can combine those types as much as you want.
/// You can also use multiple instances of one case (for example `.relative(0.4)` and `.relative(0.6)`).
public enum BottomSheetPosition: Equatable {
    /// The state where the BottomSheet is hidden.
    case hidden
    
    /// The state where only the headerContent is visible.
    case dynamicBottom
    
    /// The state where the height of the BottomSheet is equal to its content size.
    /// Only makes sense for views that don't take all available space (like ScrollVIew, Color, ...).
    case dynamic
    
    /// The state where the height of the BottomSheet is equal to its content size.
    /// It functions as top position for appleScrollBehaviour,
    /// although it doesn't make much sense to use it with dynamic.
    /// Only makes sense for views that don't take all available space (like ScrollVIew, Color, ...).
    case dynamicTop
    
    /// The state where only the headerContent is visible.
    /// The height of the BottomSheet is equal to x% of the available width.
    /// Only values between 0 and 1 make sense.
    /// Instead of 0 please use `.hidden`.
    case relativeBottom(CGFloat)
    
    /// The height of the BottomSheet is equal to x% of the available width.
    /// Only values between 0 and 1 make sense.
    /// Instead of 0 please use `.hidden`.
    case relative(CGFloat)
    
    /// The height of the BottomSheet is equal to x% of the available width.
    /// It functions as top position for appleScrollBehaviour.
    /// Only values between 0 and 1 make sense.
    /// Instead of 0 please use `.hidden`.
    case relativeTop(CGFloat)
    
    /// The state where only the headerContent is visible
    /// The height of the BottomSheet is x.
    /// Only values above 0 make sense.
    /// Instead of 0 please use `.hidden`.
    case absoluteBottom(CGFloat)
    
    /// The height of the BottomSheet is equal to x.
    /// Only values above 0 make sense.
    /// Instead of 0 please use `.hidden`.
    case absolute(CGFloat)
    
    /// The height of the BottomSheet is equal to x.
    /// It functions as top position for appleScrollBehaviour.
    /// Only values above 0 make sense.
    /// Instead of 0 please use `.hidden`.
    case absoluteTop(CGFloat)
    
    // State grouping
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
        case .dynamicTop, .relativeTop, .absoluteTop:
            return true
        default:
            return false
        }
    }
    
    internal var isDynamic: Bool {
        switch self {
        case .dynamicBottom, .dynamic, .dynamicTop:
            return true
        default:
            return false
        }
    }
    
    // Hight calculation
    internal func asScreenHeight(with maxBottomSheetHeight: CGFloat) -> CGFloat? {
        switch self {
        case .hidden:
            return 0
        case .dynamic, .dynamicTop, .dynamicBottom:
            return nil
        case .relative(let value), .relativeBottom(let value), .relativeTop(let value):
            return maxBottomSheetHeight * value
        case .absolute(let value), .absoluteBottom(let value), .absoluteTop(let value):
            return value
        }
    }
}
