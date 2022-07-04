//
//  BottomSheetView+BackgroundBlur.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

public extension BottomSheet {
    func enableBackgroundBlur(
        _ bool: Bool = true
    ) -> BottomSheet {
        self.configuration.isBackgroundBlurEnabled = bool
        return self
    }
    
    func backgroundBlurMaterial(
        _ material: EffectView
    ) -> BottomSheet {
        self.configuration.backgroundBlurMaterial = material
        return self
    }
}
