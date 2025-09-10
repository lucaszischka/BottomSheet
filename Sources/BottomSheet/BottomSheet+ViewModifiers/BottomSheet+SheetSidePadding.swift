//
//  BottomSheet+SheetSidePadding.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import Foundation
import SwiftUI

public extension BottomSheet {
    
    /// Gives padding to specific edges of the sheet
    ///
    /// - Parameters:
    ///   - edges: The edges to apply padding to. Defaults to `.all`.
    ///   - length: The amount of padding to apply to the specified edges. Defaults to `0.0`.
    ///
    /// - Returns: A BottomSheet with the configured edge padding.
    func sheetSidePadding(_ edges: Edge.Set = .all, _ length: CGFloat = 0.0) -> BottomSheet {
        let edgeInsets = EdgeInsets(
            top: edges.contains(.top) ? length : 0,
            leading: edges.contains(.leading) ? length : 0,
            bottom: edges.contains(.bottom) ? length : 0,
            trailing: edges.contains(.trailing) ? length : 0
        )
        self.configuration.sheetSidePadding = edgeInsets
        return self
    }
    
    /// Gives equal padding to all edges of the sheet
    ///
    /// - Parameters:
    ///   - padding: The amount of padding to apply to all edges. Defaults to `0.0`.
    ///
    /// - Returns: A BottomSheet with the configured padding.
    func sheetSidePadding(_ padding: CGFloat = 0.0) -> BottomSheet {
        self.configuration.sheetSidePadding = EdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
        return self
    }
}
