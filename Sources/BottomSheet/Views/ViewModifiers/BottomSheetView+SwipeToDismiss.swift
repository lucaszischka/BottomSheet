//
//  BottomSheetView+SwipeToDismiss.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import Foundation

public extension BottomSheet {
    func enableSwipeToDismiss(
        _ bool: Bool = true
    ) -> BottomSheet {
        self.configuration.isSwipeToDismissEnabled = bool
        return self
    }
}
