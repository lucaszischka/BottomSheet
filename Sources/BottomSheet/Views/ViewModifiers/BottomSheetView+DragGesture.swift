//
//  BottomSheetView+DragGesture.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

extension BottomSheetView {
    @inlinable
    func onDragChanged(
        _ perform: @escaping (
            DragGesture.Value
        ) -> Void
    ) -> BottomSheetView {
        self.configuration.onDragChanged = perform
        return self
    }
    
    @inlinable
    func onDragEnded(
        _ perform: @escaping (
            DragGesture.Value
        ) -> Void
    ) -> BottomSheetView {
        self.configuration.onDragEnded = perform
        return self
    }
}
