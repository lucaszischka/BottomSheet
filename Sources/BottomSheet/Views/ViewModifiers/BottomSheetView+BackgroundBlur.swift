//
//  BottomSheetView+BackgroundBlur.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

extension BottomSheetView {
    @inlinable
    func enableBackgroundBlur(
        _ bool: Bool = true
    ) -> BottomSheetView {
        self.configuration.isBackgroundBlurEnabled = bool
        return self
    }
    
    @inlinable
    func backgroundBlurMaterial(
        _ material: EffectView
    ) -> BottomSheetView {
        self.configuration.backgroundBlurMaterial = material
        return self
    }
}
