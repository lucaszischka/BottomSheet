//
//  BottomSheet+RelativeSheetWidth.swift
//  
//
//  Created by Robin Pel on 05/09/2022.
//

import Foundation

public extension BottomSheet {
    
    /// Makes it possible to configure a custom sheet width.
    ///
    /// - Parameters:
    ///   - width: The amount of width of the screen the sheet should occupy, 0.5 = 50%, 0.251 = 25.1%, etc.
    ///
    /// - Returns: A BottomSheet with the configured width.
    func relativeSheetWidth(_ width: Double? = nil) -> BottomSheet {
        self.configuration.relativeSheetWidth = width
        return self
    }
}
