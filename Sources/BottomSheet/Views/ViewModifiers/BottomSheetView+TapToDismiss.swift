//
//  BottomSheetView+TapToDismiss.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import Foundation

public extension BottomSheet {
    func enableTapToDismiss(
        _ bool: Bool = true
    ) -> BottomSheet {
        self.configuration.isTapToDismissEnabled = bool
        return self
    }
}
