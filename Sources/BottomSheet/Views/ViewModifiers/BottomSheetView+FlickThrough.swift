//
//  BottomSheetView+FlickThrough.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import Foundation

public extension BottomSheet {
    func enableFlickThrough(
        _ bool: Bool = true
    ) -> BottomSheet {
        self.configuration.isFlickThroughEnabled = bool
        return self
    }
}
