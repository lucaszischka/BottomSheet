//
//  BottomSheet+DragIndicator.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

public extension BottomSheet {
    
    /// Adds a drag indicator to the BottomSheet.
    ///
    /// On iPhone it is centered above the headerContent.
    /// On Mac and iPad it is centered above the mainContent,
    /// To change the color of the drag indicator please use the `.dragIndicatorColor()` modifier.
    ///
    /// - Parameters:
    ///   - bool: A boolean whether the option is enabled.
    ///
    /// - Returns: A BottomSheet with a drag indicator.
    func showDragIndicator(_ bool: Bool = true) -> BottomSheet {
        self.configuration.isDragIndicatorShown = bool
        return self
    }
    
    /// Changes the color of the drag indicator.
    ///
    /// Changing the color does not affect whether the drag indicator is shown.
    /// To toggle the drag indicator please use the `.showDragIndicator()` modifier.
    ///
    /// - Parameters:
    ///   - color: The new color.
    ///
    /// - Returns: A view with a different colored drag indicator.
    func dragIndicatorColor(_ color: Color) -> BottomSheet {
        self.configuration.dragIndicatorColor = color
        return self
    }
    
    /// Replaces the action that will be performed when the drag indicator is tapped.
    ///
    /// The `GeometryProxy` parameter can be used for calculations.
    /// You need to switch the positions and dismiss the keyboard yourself.
    /// The `GeometryProxy`'s height contains the bottom safe area inserts on iPhone.
    /// The `GeometryProxy`'s height contains the top safe area inserts on iPad and Mac.
    ///
    /// - Parameters:
    ///   - perform: The action to perform when the drag indicator is tapped.
    ///
    /// - Returns: A BottomSheet with a custom on drag indicator action.
    func dragIndicatorAction(_ action: @escaping (GeometryProxy) -> Void) -> BottomSheet {
        self.configuration.dragIndicatorAction = action
        return self
    }
}
