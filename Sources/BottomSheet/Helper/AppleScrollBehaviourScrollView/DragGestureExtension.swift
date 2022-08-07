//
//  DragGestureExtension.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

#if !os(macOS)
import SwiftUI

internal extension DragGesture {
    enum DragState: Equatable {
        case none
        case changed(value: DragGesture.Value)
        case ended(value: DragGesture.Value)
    }
}
#endif
