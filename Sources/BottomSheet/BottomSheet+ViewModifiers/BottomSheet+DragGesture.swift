//
//  BottomSheet+DragGesture.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

public extension BottomSheet {
    
    /// Adds an action to perform when the gesture’s value changes.
    ///
    /// - Parameters:
    ///   - action: The action to perform when its gesture’s value changes.
    ///   The `action` closure’s parameter contains the gesture’s new value.
    ///
    /// - Returns: The BottomSheet triggers `action` when its gesture’s value changes.
    func onDragChanged(
        _ perform: @escaping (
            DragGesture.Value
        ) -> Void
    ) -> BottomSheet {
        self.configuration.onDragChanged = perform
        return self
    }
    
    /// Adds an action to perform when the gesture ends.
    ///
    /// - Parameters:
    ///   - action: The action to perform when its gesture ends.
    ///   The `action` closure’s parameter contains the final value of the gesture.
    ///
    /// - Returns: The BottomSheet triggers `action` when its gesture ends.
    func onDragEnded(
        _ perform: @escaping (
            DragGesture.Value
        ) -> Void
    ) -> BottomSheet {
        self.configuration.onDragEnded = perform
        return self
    }
    
    /// A action that will be performed when the user drags the sheet down.
    ///
    /// The `GeometryProxy`and `DragGesture.Value` parameter can be used for calculations.
    /// This replaces the default action.
    /// You need to switch the positons, account for the revesed drag direction on iPad and Mac
    /// and dismiss the keyboard yourself.
    ///
    /// - Parameters:
    ///   - perform: The action to perform when the drag indicator is tapped.
    ///
    /// - Returns: A BottomSheet with a custom on drag indicator action.
    func dragPositionSwitchAction(
        _ action: @escaping (
            GeometryProxy,
            DragGesture.Value
        ) -> Void
    ) -> BottomSheet {
        self.configuration.dragPositionSwitchAction = action
        return self
    }
}
