//
//  BottomSheet+CustomAnimation.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

public extension BottomSheet {
    
    /// Applies the given animation to the BottomSheet when any value changes.
    ///
    /// - Parameters:
    ///   - animation: The animation to apply. If animation is nil, the view doesn’t animate.
    ///
    /// - Returns: A view that applies `animation` to the BottomSheet.
    func customAnimation(_ animation: Animation?) -> BottomSheet {
        self.configuration.animation = animation
        return self
    }
}
