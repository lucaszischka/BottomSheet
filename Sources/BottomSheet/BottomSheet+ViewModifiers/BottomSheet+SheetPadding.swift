//
//  BottomSheet+SheetPadding.swift
//  
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import Foundation

public extension BottomSheet {
    
    /// Gives padding to the sheet
    ///
    /// - Parameters:
    ///   - padding: The padding to use for the bottom sheet.
    ///
    /// - Returns: A BottomSheet with the configured padding.
    func sheetPadding(_ padding: CGFloat = 0.0) -> BottomSheet {
        self.configuration.sheetPadding = padding
        return self
    }
}
