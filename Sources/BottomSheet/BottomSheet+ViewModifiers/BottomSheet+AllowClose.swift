//
//  BottomSheet+AllowClose.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

public extension BottomSheet {
    /// 设置是否允许关闭BottomSheet
    ///
    /// - Parameter allowClose: 是否允许关闭
    func allowClose(_ allowClose: Bool) -> BottomSheet {
        self.configuration.allowClose = allowClose
        return self
    }
} 