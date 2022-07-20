//
//  BottomSheet+DragIndicator.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

public extension BottomSheet {
    
    /// Adds a drag indicator to the headerContent in the middle.
    ///
    /// - Parameters:
    ///   - bool: A boolean whether the option is enabled.
    ///
    /// - Returns: A BottomSheet with a drag indicator.
    func showDragIndicator(
        _ bool: Bool = true
    ) -> BottomSheet {
        self.configuration.isDragIndicatorShown = bool
        return self
    }
    
    /// Changes the color used by the `.showDragIndicator()` option.
    ///
    /// Changing the color does not affect whether the `.showDragIndicator()` option is enabled.
    ///
    /// - Parameters:
    ///   - color: The new color.
    ///
    /// - Returns: A view with a diffrent color used by the `.showDragIndicator()` option.
    func dragIndicatorColor(
        _ color: Color
    ) -> BottomSheet {
        self.configuration.dragIndicatorColor = color
        return self
    }
    
    /// A action that will be performed when the drag indicator is tapped.
    ///
    /// The `GeometryProxy` parameter can be used for calculations.
    /// This replaces the default action. You need to switch the positons and dismiss the keyboard yourself.
    ///
    /// - Parameters:
    ///   - perform: The action to perform when the drag indicator is tapped.
    ///
    /// - Returns: A BottomSheet with a custom on drag indicator action.
    func dragIndicatorAction(
        _ action: @escaping (
            GeometryProxy
        ) -> Void
    ) -> BottomSheet {
        self.configuration.dragIndicatorAction = action
        return self
    }
}
