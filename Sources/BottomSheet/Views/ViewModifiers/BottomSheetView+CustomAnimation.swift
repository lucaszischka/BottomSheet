//
//  BottomSheetView+CustomAnimation.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

public extension BottomSheet {
    
    /// Applies the given animation to this view when the specified value changes.
    ///
    /// - Parameters:
    ///   - animation: The animation to apply. If animation is nil, the view doesn’t animate.
    ///
    /// - Returns: A view that applies `animation` to this view.
    func customAnimation(
        _ animation: Animation?
    ) -> BottomSheet {
        self.configuration.animation = animation
        return self
    }
}
