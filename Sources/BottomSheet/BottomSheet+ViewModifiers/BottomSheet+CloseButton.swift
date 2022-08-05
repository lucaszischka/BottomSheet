//
//  BottomSheet+CloseButton.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import Foundation

public extension BottomSheet {
    
    /// Adds a close button to the headerContent on the trailing side.
    ///
    /// To perform a custom action when the BottomSheet is closed (not only via the close button),
    /// please use the `.onDismiss()` option.
    ///
    /// - Parameters:
    ///   - bool: A boolean whether the option is enabled.
    ///
    /// - Returns: A BottomSheet with a close button.
    func showCloseButton(_ bool: Bool = true) -> BottomSheet {
        self.configuration.isCloseButtonShown = bool
        return self
    }
}
