//
//  BottomSheet+SheetWidth.swift
//  
//
//  Created by Robin Pel on 05/09/2022.
//

import Foundation

public extension BottomSheet {
    
    /// Makes it possible to configure a custom sheet width.
    ///
    /// - Parameters:
    ///   - width: The width to use for the bottom sheet.
    ///
    /// - Returns: A BottomSheet with the configured width.
    func sheetWidth(_ width: BottomSheetWidth = .platformDefault) -> BottomSheet {
        self.configuration.sheetWidth = width
        return self
    }
}
