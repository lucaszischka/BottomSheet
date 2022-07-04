//
//  BottomSheetView+SwipeToDismiss.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import Foundation

extension BottomSheetView {
    @inlinable
    func enableSwipeToDismiss(
        _ bool: Bool = true
    ) -> BottomSheetView {
        self.configuration.isSwipeToDismissEnabled = bool
        return self
    }
}
