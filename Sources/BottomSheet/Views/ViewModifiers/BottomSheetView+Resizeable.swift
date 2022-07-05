//
//  BottomSheetView+Resizeable.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import Foundation

public extension BottomSheet {
    
    /// Makes it possible to resize the BottomSheet.
    ///
    /// - Parameters:
    ///   - bool: A boolean whether the option is enabled.
    ///
    /// - Returns: A BottomSheet that can be resized.
    func isResizeable(
        _ bool: Bool = true
    ) -> BottomSheet {
        self.configuration.isResizeable = bool
        return self
    }
}
