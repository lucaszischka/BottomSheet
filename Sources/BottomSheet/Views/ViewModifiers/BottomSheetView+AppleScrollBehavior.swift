//
//  BottomSheetView+AppleScrollBehavior.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import Foundation

public extension BottomSheet {
    
    /// Packs the mainContent into a ScrollView.
    ///
    /// Behavior on the iPhone:
    /// - The ScrollView is only enabled (scrollable) when the BottomSheet is in a `...Top` position.
    /// - If the offset of the ScrollView becomes less than or equal to 0,
    /// the BottomSheet is pulled down instead of scrolling.
    ///
    /// This behavior is not present on the iPad or Mac.
    ///
    /// - Parameters:
    ///   - bool: A boolean whether the option is enabled.
    ///
    /// - Returns: A BottomSheet where the mainContent is inside a ScrollView.
    func enableAppleScrollBehavior(
        _ bool: Bool = true
    ) -> BottomSheet {
        self.configuration.isAppleScrollBehaviorEnabled = bool
        return self
    }
}
