//
//  BottomSheetView+Resizeable.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import Foundation

extension BottomSheetView {
    @inlinable
    func isResizeable(
        _ bool: Bool = true
    ) -> BottomSheetView {
        self.configuration.isResizeable = bool
        return self
    }
}
