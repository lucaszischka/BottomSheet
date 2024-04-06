//
//  BottomSheetConfiguration.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

internal class BottomSheetConfiguration: Equatable {
    // For animating changes
    static func == (
        lhs: BottomSheetConfiguration,
        rhs: BottomSheetConfiguration
    ) -> Bool {
        return lhs.animation == rhs.animation &&
        lhs.backgroundBlurMaterial == rhs.backgroundBlurMaterial &&
        lhs.backgroundViewID == rhs.backgroundViewID &&
        lhs.dragIndicatorColor == rhs.dragIndicatorColor &&
        lhs.isAppleScrollBehaviorEnabled == rhs.isAppleScrollBehaviorEnabled &&
        lhs.isBackgroundBlurEnabled == rhs.isBackgroundBlurEnabled &&
        lhs.isCloseButtonShown == rhs.isCloseButtonShown &&
        lhs.isContentDragEnabled == rhs.isContentDragEnabled &&
        lhs.isDragIndicatorShown == rhs.isDragIndicatorShown &&
        lhs.isFlickThroughEnabled == rhs.isFlickThroughEnabled &&
        lhs.isResizable == rhs.isResizable &&
        lhs.isSwipeToDismissEnabled == rhs.isSwipeToDismissEnabled &&
        lhs.isTapToDismissEnabled == rhs.isTapToDismissEnabled &&
        lhs.iPadFloatingSheet == rhs.iPadFloatingSheet &&
        lhs.sheetWidth == rhs.sheetWidth &&
        lhs.accountForKeyboardHeight == rhs.accountForKeyboardHeight &&
        lhs.iPadSheetAlignment == rhs.iPadSheetAlignment &&
        lhs.sheetSidePadding == rhs.sheetSidePadding
    }
    
    var animation: Animation? = .spring(
        response: 0.5,
        dampingFraction: 0.75,
        blendDuration: 1
    )
    var backgroundBlurMaterial: VisualEffect = .system
    var backgroundViewID: UUID?
    var backgroundView: AnyView?
    var dragIndicatorAction: ((GeometryProxy) -> Void)?
    var dragIndicatorColor: Color = Color.tertiaryLabel
    var dragPositionSwitchAction: ((
        GeometryProxy,
        DragGesture.Value
    ) -> Void)?
    var isAppleScrollBehaviorEnabled: Bool = false
    var isBackgroundBlurEnabled: Bool = false
    var isCloseButtonShown: Bool = false
    var isContentDragEnabled: Bool = false
    var isDragIndicatorShown: Bool = true
    var isFlickThroughEnabled: Bool = true
    var isResizable: Bool = true
    var isSwipeToDismissEnabled: Bool = false
    var isTapToDismissEnabled: Bool = false
    var onDismiss: () -> Void = {}
    var onDragEnded: (DragGesture.Value) -> Void = { _ in }
    var onDragChanged: (DragGesture.Value) -> Void = { _ in }
    var threshold: Double = 0.3
    var iPadFloatingSheet: Bool = true
    var sheetWidth: BottomSheetWidth = .platformDefault
    var accountForKeyboardHeight: Bool = false
    var iPadSheetAlignment: Alignment = .bottomLeading
    var sheetSidePadding: CGFloat = 0.0
}
