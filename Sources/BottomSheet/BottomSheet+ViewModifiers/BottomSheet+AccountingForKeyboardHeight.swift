//
//  BottomSheet+AccountingForKeyboardHeight.swift
//
//  Created by Robin Pel.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

#if !os(macOS)
import Foundation

public extension BottomSheet {
    
    /// Adds padding to the bottom of the main content when the keyboard appears so all of the main content is visible.
    ///
    /// If the height of the sheet is smaller than the height of the keyboard, this modifier will not make the content visible.
    ///
    /// This modifier is not available on Mac, because it would not make sense there.
    ///
    /// - Parameters:
    ///   - bool: A boolean whether the option is enabled.
    ///
    /// - Returns: A BottomSheet with its main content shifted up to account for the keyboard when it has appeared.
    func enableAccountingForKeyboardHeight(_ bool: Bool = true) -> BottomSheet {
        self.configuration.accountForKeyboardHeight = bool
        return self
    }
}
#endif
