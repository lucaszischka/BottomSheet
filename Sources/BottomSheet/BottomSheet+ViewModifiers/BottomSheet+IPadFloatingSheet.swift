//
//  BottomSheet+IPadFloatingSheet.swift
//  
//
//  Created by Robin Pel on 05/09/2022.
//

import Foundation

public extension BottomSheet {
    
    /// Makes it possible to make the sheet appear like on iPhone.
    ///
    /// - Parameters:
    ///   - bool: A boolean whether the option is enabled.
    ///
    /// - Returns: A BottomSheet that will actually appear at the bottom.
    func iPadFloatingSheet(_ bool: Bool = true) -> BottomSheet {
        self.configuration.iPadFloatingSheet = bool
        return self
    }
}
