//
//  BottomSheetView+OnDismiss.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import Foundation

extension BottomSheet {
    func onDismiss(
        _ perform: @escaping () -> Void
    ) -> BottomSheet {
        self.configuration.onDismiss = perform
        return self
    }
}
