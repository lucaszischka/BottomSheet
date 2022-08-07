//
//  BottomSheet+SwipeToDismiss.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import Foundation

public extension BottomSheet {
    
    /// Makes it possible to dismiss the BottomSheet by long swiping.
    ///
    /// - Parameters:
    ///   - bool: A boolean whether the option is enabled.
    ///
    /// - Returns: A BottomSheet that can be dismissed by long swiping.
    func enableSwipeToDismiss(_ bool: Bool = true) -> BottomSheet {
        self.configuration.isSwipeToDismissEnabled = bool
        return self
    }
}
