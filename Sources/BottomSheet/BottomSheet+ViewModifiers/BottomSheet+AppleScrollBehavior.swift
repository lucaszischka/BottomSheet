//
//  BottomSheet+AppleScrollBehavior.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import Foundation

public extension BottomSheet {
    
    /// Packs the mainContent into a ScrollView.
    ///
    /// Behaviour on the iPhone:
    /// - The ScrollView is only enabled (scrollable) when the BottomSheet is in a `...Top` position.
    /// - If the offset of the ScrollView becomes less than or equal to 0,
    /// the BottomSheet is pulled down instead of scrolling.
    /// - In every other position the BottomSheet will be dragged instead
    ///
    /// This behaviour is not active on Mac and iPad, because it would not make sense there.
    ///
    /// Please note, that this feature has sometimes weird flickering,
    /// when the content of the ScrollView is smaller than itself.
    /// If you have experience with UIKit and UIScrollViews, you are welcome to open a pull request to fix this.
    ///
    /// - Parameters:
    ///   - bool: A boolean whether the option is enabled.
    ///
    /// - Returns: A BottomSheet where the mainContent is packed inside a ScrollView.
    func enableAppleScrollBehavior(_ bool: Bool = true) -> BottomSheet {
        self.configuration.isAppleScrollBehaviorEnabled = bool
        return self
    }
}
