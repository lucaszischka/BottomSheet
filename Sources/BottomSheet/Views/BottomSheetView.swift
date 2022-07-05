//
//  BottomSheetView.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

internal struct BottomSheetView<HContent: View, MContent: View>: View {
    
    // For `landscape` and `iPad` support
#if !os(macOS)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
#endif
    
    // For `iPad and `Mac` support
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
    @State var contentHeight: CGFloat = 0
    
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
        // Full screen (via GeometryReader) ZStack for aligning content
        ZStack(
            alignment: self.isIPadOrMac ? .topLeading : .bottomLeading
        ) {
            GeometryReader { geometry in
                // Full sceen background used for `backgroundBlur` and `tapToDissmiss`
                if !self.bottomSheetPosition.isHidden && (
                    self.configuration.isBackgroundBlurEnabled || self.configuration.isTapToDismissEnabled
                ) {
                    self.fullScreenBackground(
                        with: geometry
                    )
                }
                
                // BottomSheet
                self.bottomSheet(
                    with: geometry
                )
                // .clipped()
                    .measureSize { size in
                        self.contentHeight = size.height
                    }
                    .padding(
                        self.isIPadOrMac ? 10 : 0
                    )
            }
        }
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
}
