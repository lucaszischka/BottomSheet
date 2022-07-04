//
//  BottomSheetView+CloseButton.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import Foundation

public extension BottomSheet {
    func showCloseButton(
        _ bool: Bool = true
    ) -> BottomSheet {
        self.configuration.isCloseButtonShown = bool
        return self
    }
}
