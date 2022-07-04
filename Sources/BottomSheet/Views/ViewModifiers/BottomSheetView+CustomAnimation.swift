//
//  BottomSheetView+CustomAnimation.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

extension BottomSheetView {
    @inlinable
    func customAnimation(
        _ animation: Animation
    ) -> BottomSheetView {
        self.configuration.animation = animation
        return self
    }
}
