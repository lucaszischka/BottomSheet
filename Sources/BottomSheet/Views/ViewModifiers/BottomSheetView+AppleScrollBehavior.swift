//
//  BottomSheetView+AppleScrollBehavior.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import Foundation

#if !os(macOS)
public extension BottomSheet {
    func enableAppleScrollBehavior(
        _ bool: Bool = true
    ) -> BottomSheet {
        self.configuration.isAppleScrollBehaviorEnabled = bool
        return self
    }
}
#endif
