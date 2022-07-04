//
//  BottomSheetView+AppleScrollBehavior.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import Foundation

#if !os(macOS)
extension BottomSheetView {
    @inlinable
    func enableAppleScrollBehavior(
        _ bool: Bool = true
    ) -> BottomSheetView {
        self.configuration.isAppleScrollBehaviorEnabled = bool
        return self
    }
}
#endif
