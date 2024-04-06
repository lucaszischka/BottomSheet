//
//  BottomSheet+SheetSidePadding.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import Foundation

public extension BottomSheet {
    
    /// Gives horizontal padding to the sheet
    ///
    /// - Parameters:
    ///   - padding: The padding to use for the bottom sheet.
    ///
    /// - Returns: A BottomSheet with the configured padding.
    func sheetSidePadding(_ padding: CGFloat = 0.0) -> BottomSheet {
        self.configuration.sheetSidePadding = padding
        return self
    }
}
