//
//  BottomSheetView+HelperViews.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI
import Combine

internal extension BottomSheetView {
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
            .contentShape(Rectangle())
            .allowsHitTesting(self.configuration.isTapToDismissEnabled)
            .onTapGesture(perform: self.tapToDismissAction)
        // Make the background transition via opacity
            .transition(.opacity)
    }
    
    func bottomSheet(with geometry: GeometryProxy) -> some View {
        VStack(
            alignment: .center,
            spacing: 0
        ) {
            // Drag indicator on the top (iPhone and iPad not floating)
            if self.configuration.isResizable && self.configuration.isDragIndicatorShown && (!self.isIPadFloatingOrMac || !self.isIPadSheetAlignmentTop) {
                self.dragIndicator( with: geometry)
            }
            
            // The header an main content
            self.bottomSheetContent(with: geometry)
            
            // Drag indicator on the bottom (iPad floating and Mac)
            if self.configuration.isResizable && self.configuration.isDragIndicatorShown && self.isIPadFloatingOrMac && self.isIPadSheetAlignmentTop  {
                self.dragIndicator(with: geometry)
            }
        }
        // Set the height and width to its calculated values
        // The content should be aligned to the top on iPhone,
        // on iPad floating and Mac to the bottom for transition
        // to work correctly. Don't set height if `.dynamic...`
        // and currently not dragging
        .frame(
            width: self.width(with: geometry),
            height: self.bottomSheetPosition.isDynamic && self.translation == 0 ? nil : self.height(with: geometry),
            alignment: self.isIPadFloatingOrMac ? (self.isIPadSheetAlignmentTop ? .bottom : .top) : .top
        )
        // Clip BottomSheet for transition to work correctly for iPad and Mac
        .clipped()
        // BottomSheet background
        .background(
            self.bottomSheetBackground(with: geometry)
        )
        // On iPad floating and Mac the BottomSheet has a padding
        .padding(
            self.isIPadFloatingOrMac ? 10 : 0
        )
        // Add safe area top padding on iPad and Mac
        .padding(
            .top,
            self.topPadding
        )
        // Add side padding
        .padding(
            self.configuration.sheetSidePadding
        )
        // Make the BottomSheet transition via move
        .transition(.move(
            edge: self.isIPadFloatingOrMac ? (self.isIPadSheetAlignmentTop ? .top : .bottom) : .bottom
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
        // Disable animation
        .transaction { transform in
            transform.disablesAnimations = true
        }
    }
    
    func bottomSheetContent(with geometry: GeometryProxy) -> some View {
        // Add ZStack to pin header content and make main content transition correctly for iPad and Mac
        ZStack(alignment: .top) {
            // BottomSheet main content
            if self.bottomSheetPosition.isBottom && self.translation == 0 {
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
        // Reset dynamic main content height if it is hidden
        .onReceive(Just(self.bottomSheetPosition.isBottom)) { isBottom in
            if isBottom {
                // Main content is hidden, so the geometry reader can't update its height
                if self.bottomSheetPosition.isDynamic {
                    // It is `.dynamicBottom` so the height of the main content is the bottomPositionSafeAreaHeight
                    self.dynamicMainContentHeight = self.bottomPositionSafeAreaHeight
                } else {
                    // Reset main content height when not dynamic but bottom
                    self.dynamicMainContentHeight = 0
                }
            }
        }
        // Reset header content height if it is hidden
        .onReceive(Just(self.configuration.isCloseButtonShown)) { isCloseButtonShown in
            if self.headerContent == nil && !isCloseButtonShown {
                // Header content is hidden, so the geometry reader can't update its height
                // But we can, because when it is hidden its height is 0
                self.headerContentHeight = 0
            }
        }
        .onReceive(Just(self.headerContent)) { headerContent in
            if headerContent == nil && !self.configuration.isCloseButtonShown {
                // Header content is hidden, so the geometry reader can't update its height
                // But we can, because when it is hidden its height is 0
                self.headerContentHeight = 0
            }
        }
    }
    
    func main(with geometry: GeometryProxy) -> some View {
        // VStack to make frame workaround work
        VStack(alignment: .center, spacing: 0) {
            if self.configuration.isAppleScrollBehaviorEnabled && self.configuration.isResizable {
                // Content for `appleScrollBehaviour`
                if self.isIPadFloatingOrMac {
                    // On iPad floating an Mac use a normal ScrollView
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
                // highPriorityGesture is required to make dragging the bottom sheet work even when user starts dragging on buttons or other pressable items
                    .highPriorityGesture(
                        self.configuration.isContentDragEnabled && self.configuration.isResizable ?
                        self.dragGesture(with: geometry) : nil
                    )
            }
        }
        // Get dynamic main content size
        .background(self.mainGeometryReader)
        // Align content correctly and make it use all available space to fix transition
        .frame(
            maxHeight: self.maxMainContentHeight(with: geometry),
            alignment: self.isIPadFloatingOrMac ? (self.isIPadSheetAlignmentTop ? .bottom : .top) : .top
        )
        // Clip main content so that it doesn't go beneath the header content
        .clipped()
        // Align content below header content
        .padding(
            .top,
            self.headerContentHeight
        )
        // Add padding to the bottom to compensate for the keyboard (if desired)
        .padding(
            .bottom,
            self.mainContentBottomPadding
        )
        // Make the main content transition via move
        .transition(.move(
            edge: self.isIPadFloatingOrMac ? (self.isIPadSheetAlignmentTop ? .top : .bottom) : .bottom
        ))
    }
    
    var mainGeometryReader: some View {
        GeometryReader { mainGeometry in
            Color.clear
                .onReceive(Just(self.bottomSheetPosition.isDynamic)) { isDynamic in
                    if isDynamic {
                        if self.translation == 0 {
                            // Update main content height when dynamic and not dragging
                            self.dynamicMainContentHeight = mainGeometry.size.height
                        }
                    } else {
                        // Reset main content height when not dynamic
                        self.dynamicMainContentHeight = 0
                    }
                }
                .onReceive(Just(self.configuration.isAppleScrollBehaviorEnabled)) { _ in
                    if self.bottomSheetPosition.isDynamic {
                        if self.translation == 0 {
                            // Update main content height when dynamic and not dragging
                            self.dynamicMainContentHeight = mainGeometry.size.height
                        }
                    } else {
                        // Reset main content height when not dynamic
                        self.dynamicMainContentHeight = 0
                    }
                }
                .onReceive(Just(self.configuration.isResizable)) { _ in
                    if self.bottomSheetPosition.isDynamic {
                        if self.translation == 0 {
                            // Update main content height when dynamic and not dragging
                            self.dynamicMainContentHeight = mainGeometry.size.height
                        }
                    } else {
                        // Reset main content height when not dynamic
                        self.dynamicMainContentHeight = 0
                    }
                }
                .onReceive(Just(self.mainContent)) { _ in
                    if self.bottomSheetPosition.isDynamic {
                        if self.translation == 0 {
                            // Update main content height when dynamic and not dragging
                            self.dynamicMainContentHeight = mainGeometry.size.height
                        }
                    } else {
                        // Reset main content height when not dynamic
                        self.dynamicMainContentHeight = 0
                    }
                }
        }
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
    
    func header(with geometry: GeometryProxy) -> some View {
        HStack(
            alignment: .top,
            spacing: 0
        ) {
            // Header content
            if let headerContent = self.headerContent {
                headerContent
                // Add Padding when header is a title
                    .padding(
                        self.isTitleAsHeaderContent ? [
                            .leading,
                            .trailing,
                            .bottom
                        ] : []
                    )
                // Only add top padding if no drag indicator and header is a title
                    .padding(
                        (!self.configuration.isDragIndicatorShown || !self.configuration.isResizable) &&
                        self.isTitleAsHeaderContent ? .top : []
                    )
            }
            
            Spacer(minLength: 0)
            
            // Close button
            if self.configuration.isCloseButtonShown {
                self.closeButton
                // Add padding to close button
                    .padding([
                        .trailing,
                        .bottom
                    ])
                // Only add top padding if no drag indicator
                    .padding(
                        (!self.configuration.isDragIndicatorShown || !self.configuration.isResizable) ||
                        (self.isIPadFloatingOrMac && self.isIPadSheetAlignmentTop) ? .top : []
                    )
            }
        }
        // Get header content size
        .background(self.headerGeometryReader)
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
            .renderingMode(.template)
            .foregroundColor(.tertiaryLabel)
            .scaledToFit()
            .frame(
                width: 30,
                height: 30
            )
        }
        // Make it borderless for Mac
        .buttonStyle(.borderless)
    }
    
    var headerGeometryReader: some View {
        GeometryReader { headerGeometry in
            Color.clear
                .onReceive(Just(self.headerContent)) { _ in
                    self.headerContentHeight = headerGeometry.size.height
                }
                .onReceive(Just(self.configuration.isCloseButtonShown)) { _ in
                    self.headerContentHeight = headerGeometry.size.height
                }
                .onReceive(Just(self.configuration.isDragIndicatorShown)) { _ in
                    self.headerContentHeight = headerGeometry.size.height
                }
                .onReceive(Just(self.configuration.isResizable)) { _ in
                    self.headerContentHeight = headerGeometry.size.height
                }
        }
    }
    
    func bottomSheetBackground(with geometry: GeometryProxy) -> some View {
        Group {
            // Use custom BottomSheet background
            if let backgroundView = self.configuration.backgroundView {
                backgroundView
            } else {
                // Default BottomSheet background
                VisualEffectView(visualEffect: .system)
                // Add corner radius to BottomSheet background
                // On iPhone and iPad not floating only to the top corners,
                // on iPad floating and Mac to all corners
                    .cornerRadius(
                        10,
                        corners: self.isIPadFloatingOrMac ? .allCorners : [
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
    }
    
    var mainContentBottomPadding: CGFloat {
        if !self.isIPadFloatingOrMac && self.configuration.accountForKeyboardHeight {
#if !os(macOS)
            return keyboardHeight.value
#else
            // Should not be reached
            return 0
#endif
        } else {
            return 0
        }
    }
}
