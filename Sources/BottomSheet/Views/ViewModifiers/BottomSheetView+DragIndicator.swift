//
//  BottomSheetView+DragIndicator.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

extension BottomSheet {
    func showDragIndicator(
        _ bool: Bool = true
    ) -> BottomSheet {
        self.configuration.isDragIndicatorShown = bool
        return self
    }
    
    func dragIndicatorColor(
        _ color: Color
    ) -> BottomSheet {
        self.configuration.dragIndicatorColor = color
        return self
    }
}
