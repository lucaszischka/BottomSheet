//
//  BottomSheetView+OnDismiss.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import Foundation

public extension BottomSheet {
    
    /// A action that will be performed when the BottomSheet is dismissed.
    ///
    /// - Parameters:
    ///   - perform: The action to perform when the BottomSheet is dismissed.
    ///
    /// - Returns: A BottomSheet with a custom on dismiss action.
    func onDismiss(
        _ perform: @escaping () -> Void
    ) -> BottomSheet {
        self.configuration.onDismiss = perform
        return self
    }
}
