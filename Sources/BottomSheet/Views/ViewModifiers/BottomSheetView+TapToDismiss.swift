//
//  BottomSheetView+TapToDismiss.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import Foundation

extension BottomSheetView {
    @inlinable
    func enableTapToDismiss(
        _ bool: Bool = true
    ) -> BottomSheetView {
        self.configuration.isTapToDismissEnabled = bool
        return self
    }
}
