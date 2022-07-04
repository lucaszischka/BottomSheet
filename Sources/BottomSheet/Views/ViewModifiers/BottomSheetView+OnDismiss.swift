//
//  BottomSheetView+OnDismiss.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import Foundation

extension BottomSheetView {
    @inlinable
    func onDismiss(
        _ perform: @escaping () -> Void
    ) -> BottomSheetView {
        self.configuration.onDismiss = perform
        return self
    }
}
