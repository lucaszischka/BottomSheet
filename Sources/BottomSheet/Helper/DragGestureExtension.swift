//
//  DragGestureExtension.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021-2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

internal extension DragGesture {
    enum DragState {
        case none
        case changed(value: DragGesture.Value)
        case ended(value: DragGesture.Value)
    }
}
