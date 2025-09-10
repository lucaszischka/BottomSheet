//
//  BottomSheetView.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

internal struct BottomSheetView<HContent: View, MContent: View>: View {
    @GestureState var isDragging: Bool = false
    @State var lastDragValue: DragGesture.Value?

    // For iPhone landscape and iPad support
#if !os(macOS)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
#endif
    
    @Binding var bottomSheetPosition: BottomSheetPosition
    @State var translation: CGFloat = 0
    
#if !os(macOS)
    // For `appleScrollBehaviour`
    @State var isScrollEnabled: Bool = false
    @State var dragState: DragGesture.DragState = .none
#endif
    
    // View heights
    @State var headerContentHeight: CGFloat = 0
    @State var dynamicMainContentHeight: CGFloat = 0
    
#if !os(macOS)
    @ObservedObject var keyboardHeight: KeyboardHeight = KeyboardHeight()
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
                // On iPad floating and Mac the BottomSheet is aligned to the top left
                // On iPhone and iPad not floating it is aligned to the bottom center,
                // in horizontal mode to the bottom left
                alignment: self.isIPadFloatingOrMac ? self.configuration.iPadSheetAlignment : .bottomLeading
            ) {
                // Hide everything when the BottomSheet is hidden
                if !self.bottomSheetPosition.isHidden {
                    // Full screen background for aligning and used by `backgroundBlur` and `tapToDismiss`
                    self.fullScreenBackground(with: geometry)
                    
                    // The BottomSheet itself
                    self.bottomSheet(with: geometry)
                }
            }
            // Handle drag ended or cancelled
            // Drag cancellation can happen e.g. when user drags from bottom of the screen to show app switcher
            .valueChanged(value: isDragging, onChange: { isDragging in
                if lastDragValue != nil && !isDragging {
                    // Perform custom onEnded action
                    self.configuration.onDragEnded(lastDragValue!)
                    
                    // Switch the position based on the translation and screen height
                    self.dragPositionSwitch(
                        with: geometry,
                        value: lastDragValue!
                    )
                    
                    // Reset translation and last drag value, because the dragging ended
                    self.translation = 0
                    self.lastDragValue = nil
                    // Dismiss the keyboard after drag
                    self.endEditing()
                }
            })
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
                value: self.headerContentHeight
            )
            .animation(
                self.configuration.animation,
                value: self.dynamicMainContentHeight
            )
            .animation(
                self.configuration.animation,
                value: self.configuration
            )
        }
        // Make the GeometryReader ignore specific safe area (for transition to work)
        // On iPhone and iPad not floating ignore bottom safe area, because the BottomSheet moves to the bottom edge
        // On iPad floating and Mac ignore top safe area, because the BottomSheet moves to the top edge
        .ignoresSafeAreaCompatible(
            .container,
            edges: self.isIPadFloatingOrMac ? (self.isIPadSheetAlignmentTop ? .top : .bottom) : .bottom
        )
    }
}
