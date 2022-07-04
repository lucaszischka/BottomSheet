//
//  BottomSheetView+FlickThrough.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import Foundation

extension BottomSheetView {
    @inlinable
    func enableFlickThrough(
        _ bool: Bool = true
    ) -> BottomSheetView {
        self.configuration.isFlickThroughEnabled = bool
        return self
    }
}
