//
//  BottomSheetView+Configuration.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

internal class BottomSheetConfiguration: Equatable {
    static func == (
        lhs: BottomSheetConfiguration,
        rhs: BottomSheetConfiguration
    ) -> Bool {
        return lhs.animation == rhs.animation &&
        lhs.dragIndicatorColor == rhs.dragIndicatorColor &&
        lhs.isAppleScrollBehaviorEnabled == rhs.isAppleScrollBehaviorEnabled &&
        lhs.isBackgroundBlurEnabled == rhs.isBackgroundBlurEnabled &&
        lhs.isCloseButtonShown == rhs.isCloseButtonShown &&
        lhs.isContentDragEnabled == rhs.isContentDragEnabled &&
        lhs.isDragIndicatorShown == rhs.isDragIndicatorShown &&
        lhs.isResizeable == rhs.isResizeable &&
        lhs.isTapToDismissEnabled == rhs.isTapToDismissEnabled
    }
    
    var animation: Animation? = .spring(
        response: 0.5,
        dampingFraction: 0.75,
        blendDuration: 1
    )
    var backgroundBlurMaterial: VisualEffect = .system
#if os(macOS)
    var backgroundView: AnyView = AnyView(
        VisualEffectView(
            effect: .system
        )
            .cornerRadius(
                10
            )
    )
#else
    var backgroundView: AnyView = AnyView(
        VisualEffectView(
            effect: .system
        )
            .cornerRadius(
                10,
                corners: UIDevice.current.userInterfaceIdiom == .pad ? .allCorners : [
                    .topRight,
                    .topLeft
                ]
            )
    )
#endif
    var dragIndicatorColor: Color = Color.tertiaryLabel
    var isAppleScrollBehaviorEnabled: Bool = false
    var isBackgroundBlurEnabled: Bool = false
    var isCloseButtonShown: Bool = false
    var isContentDragEnabled: Bool = false
    var isDragIndicatorShown: Bool = true
    var isFlickThroughEnabled: Bool = true
    var isResizeable: Bool = true
    var isSwipeToDismissEnabled: Bool = false
    var isTapToDismissEnabled: Bool = false
    var onDismiss: () -> Void = {}
    var onDragEnded: (
        DragGesture.Value
    ) -> Void = { _ in }
    var onDragChanged: (
        DragGesture.Value
    ) -> Void = { _ in }
}
