//
//  BottomSheetWidth.swift
//
//  Created by Robin Pel.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

/// `BottomSheetWidth` defines the possible BottomSheet widths that can be configured.
///
/// Currently there are three options:
/// - `.platformDefault`, which let's the library decide the width while taking the platform into account.
/// - `.relative(CGFloat)`, which sets the width to a certain percentage of the available width.
/// - `.absolute(CGFloat)`, which sets the width to the given amount.
public enum BottomSheetWidth: Equatable {
    
    /// Apply the platform default width to the sheet.
    ///
    /// As from `BottomSheetView.platformDefaultWidth`:
    /// - Mac: 30% of the available width.
    /// - iPad: 30% of the available width.
    /// - iPhone landscape: 40% of the available width.
    /// - iPhone portrait: 100% of the available width.
    case platformDefault
    
    /// The width of the BottomSheet is equal to x% of the available width.
    /// Only values between 0 and 1 make sense.
    /// Instead of 0 please use `BottomSheetPosition.hidden`.
    case relative(CGFloat)
    
    /// The width of the BottomSheet is equal to x.
    /// Only values above 0 make sense.
    /// Instead of 0 please use `BottomSheetPosition.hidden`.
    case absolute(CGFloat)
}
