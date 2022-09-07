//
//  BottomSheetWidth.swift
//  
//
//  Created by Robin Pel on 07/09/2022.
//

import SwiftUI

/// `BottomSheetWidth` defines the possible bottom sheet widths that can be configured.
public enum BottomSheetWidth: Equatable {
    
    /// Apply the platform default width to the sheet.
    case platformDefault
    
    /// The width of the sheet has to be x% of the available width.
    case relative(CGFloat)
    
    /// The width of the sheet has to be x.
    case absolute(CGFloat)
}
