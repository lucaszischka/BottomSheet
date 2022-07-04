//
//  BottomSheetView+Configuration.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

public extension BottomSheetView {
    class Configuration: Equatable {
        public static func == (
            lhs: BottomSheetView<HContent, MContent, V>.Configuration,
            rhs: BottomSheetView<HContent, MContent, V>.Configuration
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
        
        public var animation: Animation = .spring(
            response: 0.5,
            dampingFraction: 0.75,
            blendDuration: 1
        )
#if os(macOS)
        public var backgroundBlurMaterial: EffectView = EffectView(
            material: .popover
        )
#else
        public var backgroundBlurMaterial: EffectView = EffectView(
            material: .systemUltraThinMaterial
        )
#endif
#if os(macOS)
        public var backgroundView: AnyView = AnyView(
            EffectView(
                material: .popover
            )
                .cornerRadius(
                    10
                )
        )
#else
        public var backgroundView: AnyView = AnyView(
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
        public var dragIndicatorColor: Color = Color.tertiaryLabel
        public var isAppleScrollBehaviorEnabled: Bool = false
        public var isBackgroundBlurEnabled: Bool = false
        public var isCloseButtonShown: Bool = false
        public var isContentDragEnabled: Bool = false
        public var isDragIndicatorShown: Bool = true
        public var isFlickThroughEnabled: Bool = true
        public var isResizeable: Bool = true
        public var isSwipeToDismissEnabled: Bool = false
        public var isTapToDismissEnabled: Bool = false
        public var onDismiss: () -> Void = {}
        public var onDragEnded: (
            DragGesture.Value
        ) -> Void = { _ in
        }
        public var onDragChanged: (
            DragGesture.Value
        ) -> Void = { _ in
        }
    }
}
