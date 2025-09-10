//
//  BottomSheet+iPadSheetAlignment.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import Foundation
import SwiftUI

public extension BottomSheet {
    
    /// Makes it possible to align the sheet at different places on iPad if floating sheet is disabled
    ///
    /// - Parameters:
    ///   - alignment: An alignment for the bottom sheet
    ///
    /// - Returns: A BottomSheet that will align to what's specified
    func iPadSheetAlignment(_ alignment: Alignment = .bottomLeading) -> BottomSheet {
        self.configuration.iPadSheetAlignment = alignment
        return self
    }
}
