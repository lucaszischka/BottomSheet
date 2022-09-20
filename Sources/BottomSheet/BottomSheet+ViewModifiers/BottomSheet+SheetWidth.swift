//
//  BottomSheet+SheetWidth.swift
//
//  Created by Robin Pel.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import Foundation

public extension BottomSheet {
    
    /// Makes it possible to configure a custom sheet width.
    ///
    /// Can be relative through `BottomSheetWidth.relative(x)`.
    /// Can be absolute through `BottomSheetWidth.absolute(x)`.
    /// Set to `BottomSheetWidth.platformDefault` to let the library decide the width.
    /// 
    /// - Parameters:
    ///   - width: The width to use for the bottom sheet.
    ///
    /// - Returns: A BottomSheet with the configured width.
    func sheetWidth(_ width: BottomSheetWidth = .platformDefault) -> BottomSheet {
        self.configuration.sheetWidth = width
        return self
    }
}
