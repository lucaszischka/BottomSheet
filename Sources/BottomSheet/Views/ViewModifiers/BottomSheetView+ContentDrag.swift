//
//  BottomSheetView+ContentDrag.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import Foundation

public extension BottomSheet {
    func enableContentDrag(
        _ bool: Bool = true
    ) -> BottomSheet {
        self.configuration.isContentDragEnabled = bool
        return self
    }
}
