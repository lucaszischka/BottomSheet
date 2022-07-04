//
//  BottomSheetView+CustomAnimation.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

public extension BottomSheet {
    func customAnimation(
        _ animation: Animation
    ) -> BottomSheet {
        self.configuration.animation = animation
        return self
    }
}
