//
//  BottomSheetView+BackgroundBlur.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

public extension BottomSheet {
    
    /// Adds a fullscreen blur layer below the BottomSheet.
    ///
    /// The transparency of the layer is proportional to the size of the BottomSheet.
    ///
    /// - Parameters:
    ///   - bool: A boolean whether the option is enabled.
    ///
    /// - Returns: A view that has a blur layer below the BottomSheet.
    func enableBackgroundBlur(
        _ bool: Bool = true
    ) -> BottomSheet {
        self.configuration.isBackgroundBlurEnabled = bool
        return self
    }
    
    /// Changes the material used by the `.enableBackgroundBlur()` option.
    ///
    /// Changing the material does not affect whether the `.enableBackgroundBlur()` option is enabled.
    ///
    /// - Parameters:
    ///   - material: The new material.
    ///
    /// - Returns: A view with a diffrent material used by the `.enableBackgroundBlur()` option.
    func backgroundBlurMaterial(
        _ material: VisualEffect
    ) -> BottomSheet {
        self.configuration.backgroundBlurMaterial = material
        return self
    }
}
