//
//  BottomSheetView.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

internal struct BottomSheetView<HContent: View, MContent: View>: View {
    
    // For iPhone landscape and iPad support
#if !os(macOS)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
#endif
    
    // For iPad and Mac support
    var isIPadOrMac: Bool {
#if os(macOS)
        return true
#else
        if self.horizontalSizeClass == .regular && self.verticalSizeClass == .regular {
            return true
        } else {
            return false
        }
#endif
    }
    
    @Binding var bottomSheetPosition: BottomSheetPosition
    @State var translation: CGFloat = 0
    @State var contentHeight: CGFloat?
    
#if !os(macOS)
    // For `appleScrollBehaviour`
    @State var isScrollEnabled: Bool = false
    @State var dragState: DragGesture.DragState = .none
#endif
    
    // Views
    let headerContent: HContent?
    let mainContent: MContent
    
    let switchablePositions: [BottomSheetPosition]
    
    // Configuration
    let configuration: BottomSheetConfiguration
    
    var body: some View {
        // GeometryReader for size calculations
        GeometryReader { geometry in
            // ZStack for aligning content
            ZStack(
                // On iPad and Mac the BottomSheet is aligned to the top left
                // On iPhone it is aligned to the bottom center, in horizontal mode to the bottom left
                alignment: self.isIPadOrMac ? .topLeading : .bottomLeading
            ) {
                // Hide everything when the BottomSheet is hidden
                if !self.bottomSheetPosition.isHidden {
                    // Full sceen background for aligning and used by `backgroundBlur` and `tapToDissmiss`
                    if self.configuration.isBackgroundBlurEnabled || self.configuration.isTapToDismissEnabled {
                        self.fullScreenBackground(
                            with: geometry
                        )
                    }
                    
                    // The BottomSheet itself
                    self.bottomSheet(
                        with: geometry
                    )
                }
            }
            // Animate value changes
#if !os(macOS)
            .animation(
                self.configuration.animation,
                value: self.horizontalSizeClass
            )
            .animation(
                self.configuration.animation,
                value: self.verticalSizeClass
            )
#endif
            .animation(
                self.configuration.animation,
                value: self.bottomSheetPosition
            )
            .animation(
                self.configuration.animation,
                value: self.translation
            )
            .animation(
                self.configuration.animation,
                value: self.contentHeight
            )
#if !os(macOS)
            .animation(
                self.configuration.animation,
                value: self.isScrollEnabled
            )
            .animation(
                self.configuration.animation,
                value: self.dragState
            )
#endif
            .animation(
                self.configuration.animation,
                value: self.configuration
            )
        }
        // Make the GeometryReader ignore specific safe area (for transition to work)
        // On iPhone ignore bottom safe area, because the BottomSheet moves to the bottom edge
        // On iPad and Mac ignore top safe area, because the BottomSheet moves to the top edge
        .edgesIgnoringSafeArea(
            self.isIPadOrMac ? .top : .bottom
        )
    }
}
