//
//  BottomSheetView+CloseButton.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import Foundation

extension BottomSheetView {
    @inlinable
    func showCloseButton(
        _ bool: Bool = true
    ) -> BottomSheetView {
        self.configuration.isCloseButtonShown = bool
        return self
    }
}
