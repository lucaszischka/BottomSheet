//
//  BottomSheetWidth.swift
//  
//
//  Created by Robin Pel on 07/09/2022.
//

import SwiftUI

/// `BottomSheetWidth` defines the possible bottom sheet widths that can be configured.
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
    
    /// The width of the sheet has to be x% of the available width.
    ///
    /// Only values between 0 and 1 make sense.
    /// If you want to hide the sheet, please use `BottomSheetPosition.hidden`.
    case relative(CGFloat)
    
    /// The width of the sheet has to be x.
    ///
    /// Only values above 0 make sense.
    /// If you want to hide the sheet, please use `BottomSheetPosition.hidden`.
    case absolute(CGFloat)
}
