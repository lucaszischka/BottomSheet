//
//  BottomSheetView+HelperViews.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI
import Combine

internal extension BottomSheetView {
    
    // Gestures
    
    func dragGesture(with geometry: GeometryProxy) -> some Gesture {
        DragGesture()
            .onChanged { value in
                // Perform custom onChanged action
                self.configuration.onDragChanged(value)
                
                // Update translation; on iPad and Mac the drag direction is reversed
                self.translation = self.isIPadOrMac ? -value.translation.height : value.translation.height
                // Dismiss the keyboard on drag
                self.endEditing()
            }
            .onEnded { value in
                // Perform custom onEnded action
                self.configuration.onDragEnded(value)
                
                // Switch the position based on the translation and screen height
                self.dragPositionSwitch(
                    with: geometry,
                    value: value
                )
                
                // Reset translation, because the dragging ended
                self.translation = 0
                // Dismiss the keyboard after drag
                self.endEditing()
            }
    }
#if !os(macOS)
    func appleScrollViewDragGesture(
        with geometry: GeometryProxy
    ) -> some Gesture {
        DragGesture()
            .onChanged { value in
                if self.bottomSheetPosition.isTop && value.translation.height < 0 {
                    // Notify the ScrollView that the user is scrolling
                    self.dragState = .changed(value: value)
                    // Reset translation, because the user is scrolling
                    self.translation = 0
                } else {
                    // Perform custom action from the user
                    self.configuration.onDragChanged(value)
                    
                    // Notify the ScrollView that the user is dragging
                    self.dragState = .none
                    // Update translation; on iPad and Mac the drag direction is reversed
                    self.translation = self.isIPadOrMac ? -value.translation.height : value.translation.height
                }
                
                // Dismiss the keyboard on dragging/scrolling
                self.endEditing()
            }
            .onEnded { value in
                if value.translation.height < 0 && self.bottomSheetPosition.isTop {
                    // Notify the ScrollView that the user ended scrolling via dragging
                    self.dragState = .ended(value: value)
                    
                    // Reset translation, because the user ended scrolling via dragging
                    self.translation = 0
                    // Enable further interaction via the ScrollView directly
                    self.isScrollEnabled = true
                } else {
                    // Perform custom action from the user
                    self.configuration.onDragEnded(value)
                    
                    // Notify the ScrollView that the user is dragging
                    self.dragState = .none
                    // Switch the position based on the translation and screen height
                    self.dragPositionSwitch(
                        with: geometry,
                        value: value
                    )
                    
                    // Reset translation, because the dragging ended
                    self.translation = 0
                }
                
                // Dismiss the keyboard after dragging/scrolling
                self.endEditing()
            }
    }
#endif
    
    // Views
    
    func fullScreenBackground(with geometry: GeometryProxy) -> some View {
        VisualEffectView(visualEffect: self.configuration.backgroundBlurMaterial)
            .opacity(
                // When `backgroundBlur` is enabled the opacity is calculated
                // based on the current height of the BottomSheet relative to its maximum height
                // Otherwise it is 0
                self.opacity(with: geometry)
            )
        // Make the background fill the whole screen including safe area
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
            .edgesIgnoringSafeArea(.all)
        // Make the background tap-able for `tapToDismiss`
            .contentShape(Rectangle()) // TODO: Needed?
            .allowsHitTesting(self.configuration.isTapToDismissEnabled) // TODO: Needed?
            .onTapGesture(perform: self.tapToDismissAction)
        // Make the background transition via opacity
            .transition(.opacity)
    }
    
    func bottomSheet(with geometry: GeometryProxy) -> some View {
        VStack(
            alignment: .center,
            spacing: 0
        ) {
            // Drag indicator on the top (iPhone)
            if self.configuration.isResizable && self.configuration.isDragIndicatorShown && !self.isIPadOrMac {
                self.dragIndicator( with: geometry)
            }
            
            // Add ZStack to pin header content and make main content transition correctly for iPad and Mac
            ZStack(alignment: .top) {
                // BottomSheet main content
                if self.bottomSheetPosition.isBottom {
                    // In a bottom position the main content is hidden - add a Spacer to fill the height
                    Spacer(minLength: 0)
                        .frame(height: self.bottomPositionSpacerHeight)
                } else {
                    // BottomSheet main content
                    self.main(with: geometry)
                }
                
                // BottomSheet header content
                if self.headerContent != nil || self.configuration.isCloseButtonShown {
                    self.header(with: geometry)
                }
            }
            // Reset main content height if hidden
            .onReceive(Just(self.bottomSheetPosition.isBottom)) { _ in
                if self.bottomSheetPosition.isBottom, let bottomPositionSpacerHeight = self.bottomPositionSpacerHeight {
                    self.mainContentHeight = bottomPositionSpacerHeight
                } else {
                    self.mainContentHeight = 0
                }
            }
            // Reset header content height if hidden
            .onReceive(Just(self.configuration.isCloseButtonShown)) { _ in
                if self.headerContent == nil && !self.configuration.isCloseButtonShown {
                    self.headerContentHeight = 0
                }
            }
            .onReceive(Just(self.headerContent)) { _ in
                if self.headerContent == nil && !self.configuration.isCloseButtonShown {
                    self.headerContentHeight = 0
                }
            }
            
            // Drag indicator on the bottom (iPad and Mac)
            if self.configuration.isResizable && self.configuration.isDragIndicatorShown && self.isIPadOrMac {
                self.dragIndicator(with: geometry)
            }
        }
        // Set the height and width to its calculated values
        // The content should be aligned to the top on iPhone,
        // on iPad and Mac to the bottom for transition to work correctly
        .frame(
            width: self.width(with: geometry),
            height: self.height(with: geometry),
            alignment: self.isIPadOrMac ? .bottom : .top
        )
        // BottomSheet background
        .background(
            Group {
                // Use custom BottomSheet background
                if let backgroundView = self.configuration.backgroundView {
                    backgroundView
                } else {
                    // Default BottomSheet background
                    VisualEffectView(visualEffect: .system)
                    // Add corner radius to BottomSheet background
                    // On iPhone only to the top corners,
                    // on iPad and Mac to all corners
                        .cornerRadius(
                            10,
                            corners: self.isIPadOrMac ? .allCorners : [
                                .topRight,
                                .topLeft
                            ]
                        )
                }
            }
            // Make the background drag-able
                .gesture(
                    self.configuration.isResizable ? self.dragGesture(with: geometry) : nil
                )
        )
        // Clip BottomSheet for transition to work correctly for iPad and Mac
        .clipped()
        // On iPad and Mac the BottomSheet has a padding
        .padding(
            self.isIPadOrMac ? 10 : 0
        )
        // Add safe area top padding on iPad and Mac
        .padding(
            .top,
            self.iPadAndMacTopPadding
        )
        // Make the BottomSheet transition via move
        .transition(.move(
            edge: self.isIPadOrMac ? .top : .bottom
        ))
    }
    
    func dragIndicator(with geometry: GeometryProxy) -> some View {
        Button(
            action: {
                self.dragIndicatorAction(with: geometry)
            },
            label: {
                Capsule()
                // Design of the drag indicator
                    .fill(self.configuration.dragIndicatorColor)
                    .frame(
                        width: 36,
                        height: 5
                    )
                    .padding(
                        .top,
                        7.5
                    )
                    .padding(
                        .bottom,
                        7.5
                    )
                // Make the drag indicator drag-able
                    .gesture(
                        self.dragGesture(with: geometry)
                    )
            })
        // Make it borderless for Mac
            .buttonStyle(.borderless)
    }
    
    func header(with geometry: GeometryProxy) -> some View {
        HStack(
            alignment: .top,
            spacing: 0
        ) {
            // Header content
            if let headerContent = self.headerContent {
                headerContent
            }
            
            Spacer(minLength: 0)
            
            // Close button
            if self.configuration.isCloseButtonShown {
                self.closeButton
            }
        }
        // Add horizontal padding
        .padding(.horizontal)
        // Add top padding when on iPad or Mac or when the drag indicator is not shown
        .padding(
            .top,
            self.isIPadOrMac || !self.configuration.isDragIndicatorShown || !self.configuration.isResizable ? 20 : 0
        )
        // Add bottom padding when header content is nil and close button is shown
        .padding(
            .bottom,
            self.headerContent == nil && self.configuration.isCloseButtonShown ? 20 : 0
        )
        // Get header content size
        .background(
            GeometryReader { geometry in
                Color.clear
                    .onReceive(Just(self.headerContent)) { _ in
                        self.headerContentHeight = geometry.size.height
                    }
                    .onReceive(Just(self.configuration.isCloseButtonShown)) { _ in
                        self.headerContentHeight = geometry.size.height
                    }
                    .onReceive(Just(self.configuration.isDragIndicatorShown)) { _ in
                        self.headerContentHeight = geometry.size.height
                    }
                    .onReceive(Just(self.configuration.isResizable)) { _ in
                        self.headerContentHeight = geometry.size.height
                    }
            }
        )
        // Make the header drag-able
        .gesture(
            self.configuration.isResizable ? self.dragGesture(with: geometry) : nil
        )
    }
    
    var closeButton: some View {
        Button(action: self.closeSheet) {
            Image(
                "xmark.circle.fill",
                bundle: Bundle.module
            )
            // Design of the close button
                .resizable()
                .scaledToFit()
                .frame(
                    width: 30,
                    height: 30
                )
        }
        // Make it borderless for Mac
        .buttonStyle(.borderless)
    }
    
    func main(with geometry: GeometryProxy) -> some View {
        // VStack to make frame workaround work
        VStack(alignment: .center, spacing: 0) {
            if self.configuration.isAppleScrollBehaviorEnabled && self.configuration.isResizable {
                // TODO: Fix appleScrollBehaviour not working when main content doesn't is higher or equal to BottomSheet height
                // Content for `appleScrollBehavior`
                if self.isIPadOrMac {
                    // On iPad an Mac a normal ScrollView
                    ScrollView {
                        self.mainContent
                    }
                } else {
#if !os(macOS)
                    self.appleScrollView(with: geometry)
#endif
                }
            } else {
                // Main content
                self.mainContent
                // Make the main content drag-able if content drag is enabled
                    .gesture(
                        self.configuration.isContentDragEnabled && self.configuration.isResizable ? self.dragGesture(with: geometry) : nil
                    )
            }
        }
        // Get main content size
        .background(
            GeometryReader { geometry in
                Color.clear
                    .onReceive(Just(self.configuration.isAppleScrollBehaviorEnabled)) { _ in
                        self.mainContentHeight = geometry.size.height
                    }
                    .onReceive(Just(self.configuration.isResizable)) { _ in
                        self.mainContentHeight = geometry.size.height
                    }
                    .onReceive(Just(self.mainContent)) { _ in
                        self.mainContentHeight = geometry.size.height
                    }
            }
        )
        // Align content correctly and make it use all available space to fix transition
        .frame(
            maxHeight: self.maxMainContentHeight(with: geometry),
            alignment: self.isIPadOrMac ? .bottom : .top
        )
        // Clip main content so that it doesn't go beneath the header content
        .clipped()
        // Align content below header content
        .padding(
            .top,
            self.isIPadOrMac ? self.headerContentHeight : 0
        )
        // Make the main content transition via move
        .transition(.move(
            edge: self.isIPadOrMac ? .top : .bottom
        ))
    }
    
#if !os(macOS)
    func appleScrollView(with geometry: GeometryProxy) -> some View {
        UIScrollViewWrapper(
            isScrollEnabled: self.$isScrollEnabled,
            dragState: self.$dragState
        ) {
            self.mainContent
        }
        // Make ScrollView drag-able
        .gesture(
            self.isScrollEnabled ? nil : self.appleScrollViewDragGesture(with: geometry)
        )
    }
#endif
}
