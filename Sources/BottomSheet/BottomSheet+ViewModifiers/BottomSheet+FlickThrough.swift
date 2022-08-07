//
//  BottomSheet+FlickThrough.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import Foundation

public extension BottomSheet {
    
    /// Makes it possible to switch directly to the top or bottom position by long swiping.
    ///
    /// - Parameters:
    ///   - bool: A boolean whether the option is enabled.
    ///
    /// - Returns: A BottomSheet where long swiping to go directly to the top or bottom positions is enabled.
    func enableFlickThrough(_ bool: Bool = true) -> BottomSheet {
        self.configuration.isFlickThroughEnabled = bool
        return self
    }
}
