//
//  BottomSheetView+DragGesture.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

public extension BottomSheet {
    func onDragChanged(
        _ perform: @escaping (
            DragGesture.Value
        ) -> Void
    ) -> BottomSheet {
        self.configuration.onDragChanged = perform
        return self
    }
    
    func onDragEnded(
        _ perform: @escaping (
            DragGesture.Value
        ) -> Void
    ) -> BottomSheet {
        self.configuration.onDragEnded = perform
        return self
    }
}
