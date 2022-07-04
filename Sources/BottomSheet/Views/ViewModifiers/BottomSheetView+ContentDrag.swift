//
//  BottomSheetView+ContentDrag.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import Foundation

extension BottomSheetView {
    @inlinable
    func enableContentDrag(
        _ bool: Bool = true
    ) -> BottomSheetView {
        self.configuration.isContentDragEnabled = bool
        return self
    }
}
