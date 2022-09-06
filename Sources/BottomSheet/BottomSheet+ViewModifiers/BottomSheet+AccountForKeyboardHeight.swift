//
//  File.swift
//  
//
//  Created by Robin Pel on 06/09/2022.
//

import Foundation

public extension BottomSheet {
    
    /// Adds padding to the bottom of the main content when the keyboard appears so all of the main content is visible.
    ///
    /// - Note: If the height of the sheet is smaller than the height of the keyboard, this modifier will not make the content visible.
    ///
    /// - Parameters:
    ///   - bool: A boolean whether the option is enabled.
    ///
    /// - Returns: A BottomSheet with its main content shifted up to account for the keyboard when it has appeared.
    func accountForKeyboardHeight(_ bool: Bool = true) -> BottomSheet {
        self.configuration.accountForKeyboardHeight = bool
        return self
    }
}
