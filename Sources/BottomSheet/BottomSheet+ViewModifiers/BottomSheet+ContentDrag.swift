//
//  BottomSheet+ContentDrag.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import Foundation

public extension BottomSheet {
    
    /// Makes it possible to resize the BottomSheet by dragging the mainContent.
    ///
    /// Due to imitations in the SwiftUI framework,
    /// this option has no effect or even makes the BottomSheet glitch
    /// if the mainContent is packed into a ScrollView or a List.
    ///
    /// - Parameters:
    ///   - bool: A boolean whether the option is enabled.
    ///
    /// - Returns: A BottomSheet where the mainContent can be used for resizing.
    func enableContentDrag(_ bool: Bool = true) -> BottomSheet {
        self.configuration.isContentDragEnabled = bool
        return self
    }
}
