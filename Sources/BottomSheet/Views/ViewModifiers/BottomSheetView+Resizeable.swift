//
//  BottomSheetView+Resizeable.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import Foundation

public extension BottomSheet {
    func isResizeable(
        _ bool: Bool = true
    ) -> BottomSheet {
        self.configuration.isResizeable = bool
        return self
    }
}
