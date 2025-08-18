//
//  BottomSheet+HitTestAllowed.swift
//
//  Created by Pavel Alekseev.
//  Copyright © 2025 Pavel Alekseev. All rights reserved.
//

import Foundation

public extension BottomSheet {
    
    /// Override whether the background allows hit testing, independent of tap-to-dismiss setting.
    ///
    /// When enabled, users can tap through the BottomSheet background even if tap-to-dismiss is disabled.
    /// When disabled, the background blocks tap events even if tap-to-dismiss is enabled.
    ///
    /// - Parameters:
    ///   - bool: A boolean whether hit testing is allowed on the background.
    ///
    /// - Returns: A BottomSheet with custom hit testing behavior.
    func hitTestAllowed(_ bool: Bool) -> BottomSheet {
        self.configuration.isHitTestAllowed = bool
        return self
    }
}