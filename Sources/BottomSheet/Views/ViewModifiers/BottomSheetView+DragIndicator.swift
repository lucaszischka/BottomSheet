//
//  BottomSheetView+DragIndicator.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

extension BottomSheetView {
    @inlinable
    func showDragIndicator(
        _ bool: Bool = true
    ) -> BottomSheetView {
        self.configuration.isDragIndicatorShown = bool
        return self
    }
    
    @inlinable
    func dragIndicatorColor(
        _ color: Color
    ) -> BottomSheetView {
        self.configuration.dragIndicatorColor = color
        return self
    }
}
