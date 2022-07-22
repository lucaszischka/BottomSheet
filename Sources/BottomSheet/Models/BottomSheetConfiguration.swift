//
//  BottomSheetConfiguration.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

internal class BottomSheetConfiguration: Equatable {
    // TODO: Fix Equatable
    static func == (
        lhs: BottomSheetConfiguration,
        rhs: BottomSheetConfiguration
    ) -> Bool {
        return lhs.animation == rhs.animation &&
        // lhs.backgroundBlurMaterial == rhs.backgroundBlurMaterial &&
        // lhs.backgroundView == rhs.backgroundView &&
        // lhs.dragIndicatorAction == rhs.dragIndicatorAction &&
        lhs.dragIndicatorColor == rhs.dragIndicatorColor &&
        // lhs.dragPositionSwitchAction == rhs.dragPositionSwitchAction &&
        lhs.isAppleScrollBehaviorEnabled == rhs.isAppleScrollBehaviorEnabled &&
        lhs.isBackgroundBlurEnabled == rhs.isBackgroundBlurEnabled &&
        lhs.isCloseButtonShown == rhs.isCloseButtonShown &&
        lhs.isContentDragEnabled == rhs.isContentDragEnabled &&
        lhs.isDragIndicatorShown == rhs.isDragIndicatorShown &&
        lhs.isFlickThroughEnabled == rhs.isFlickThroughEnabled &&
        lhs.isResizeable == rhs.isResizeable &&
        lhs.isSwipeToDismissEnabled && rhs.isSwipeToDismissEnabled &&
        lhs.isTapToDismissEnabled == rhs.isTapToDismissEnabled // &&
        // lhs.onDismiss == rhs.onDismiss &&
        // lhs.onDragEnded == rhs.onDragEnded &&
        // lhs.onDragChanged == rhs.onDragChanged
    }
    
    var animation: Animation? = .spring(
        response: 0.5,
        dampingFraction: 0.75,
        blendDuration: 1
    )
#if os(macOS)
    var backgroundBlurMaterial: EffectView = EffectView(
        material: .popover
    )
#else
    var backgroundBlurMaterial: EffectView = EffectView(
        material: .systemUltraThinMaterial
    )
#endif
#if os(macOS)
    var backgroundView: AnyView = AnyView(
        EffectView(
            material: .popover
        )
            .cornerRadius(
                10
            )
    )
#else
    var backgroundView: AnyView = AnyView(
        EffectView(
            material: .systemUltraThinMaterial
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
    var dragIndicatorAction: (
        (
            GeometryProxy
        ) -> Void
    )?
    var dragIndicatorColor: Color = Color.tertiaryLabel
    var dragPositionSwitchAction: (
        (
            GeometryProxy,
            DragGesture.Value
        ) -> Void
    )?
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
