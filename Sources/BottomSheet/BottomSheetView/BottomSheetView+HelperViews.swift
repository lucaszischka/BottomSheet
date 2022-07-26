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
    
    func dragGesture(
        with geometry: GeometryProxy
    ) -> some Gesture {
        DragGesture()
            .onChanged { value in
                // Perform custom onChanged action
                self.configuration.onDragChanged(
                    value
                )
                
                // Update translation; on iPad and Mac the drag direction is reversed
                self.translation = self.isIPadOrMac ? -value.translation.height : value.translation.height
                // Dismiss the keyboard on drag
                self.endEditing()
            }
            .onEnded { value in
                // Perform custom onEnded action
                self.configuration.onDragEnded(
                    value
                )
                
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
                    self.dragState = .changed(
                        value: value
                    )
                    // Reset translation, because the user is scrolling
                    self.translation = 0
                } else {
                    // Perform custom action from the user
                    self.configuration.onDragChanged(
                        value
                    )
                    
                    // Notify the ScrollView that the user is dragging
                    self.dragState = .none
                    // Update translation; on iPad and Mac the drag direction is reversed
                    self.translation = self.isIPadOrMac ? -value.translation.height : value.translation.height
                }
                
                // Dismiss the keyboard on drag/scroll
                self.endEditing()
            }
            .onEnded { value in
                if value.translation.height < 0 && self.bottomSheetPosition.isTop {
                    // Notify the ScrollView that the user ended to scroll
                    self.dragState = .ended(
                        value: value
                    )
                    
                    // Reset translation, because the user ended to scroll
                    self.translation = 0
                    // Enable further interaction via the ScrollView directly
                    self.isScrollEnabled = true
                } else {
                    // Perform custom action from the user
                    self.configuration.onDragEnded(
                        value
                    )
                    
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
                
                // Dismiss the keyboard after drag/scroll
                self.endEditing()
            }
    }
#endif
    
    // Views
    
    func fullScreenBackground(
        with geometry: GeometryProxy
    ) -> some View {
        VisualEffectView(visualEffect: self.configuration.backgroundBlurMaterial)
            .opacity(
                // When `.backgroundBlur` is enabled the opacity is calculated
                // based on the current height of the BottomSheet, else it is 0
                self.opacity(
                    with: geometry
                )
            )
        // Make the background fill the whole screen
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
            .edgesIgnoringSafeArea(
                .all
            )
        // Make the background tap-able
            .contentShape(
                Rectangle()
            )
            .allowsHitTesting(
                self.configuration.isTapToDismissEnabled
            )
            .onTapGesture(
                perform: self.tapToDismissAction
            )
        // Make the background transition via opacity
            .transition(
                .opacity
            )
    }
    
    func bottomSheet(
        with geometry: GeometryProxy
    ) -> some View {
        VStack(
            alignment: .center,
            spacing: 0
        ) {
            // Drag indicator on the top (iPhone)
            if self.configuration.isResizeable && self.configuration.isDragIndicatorShown && !self.isIPadOrMac {
                self.dragIndicator(
                    with: geometry
                )
            }
            
            if self.isIPadOrMac {
                // TODO: Fix header not fixed on iPad and Mac
                ZStack(alignment: .top) {
                    // BottomSheet main content
                    if self.bottomSheetPosition.isBottom {
                        // In a bottom position the main content is hidden - add a Spacer to fill the height
                        Spacer(minLength: 0)
                            .frame(
                                height: self.bottomPositionSpacerHeight
                            )
                    } else {
                        // Main content
                        self.bottomSheetContent(
                            with: geometry
                        )
                    }
                    
                    // BottomSheet header content
                    if self.headerContent != nil || self.configuration.isCloseButtonShown {
                        self.header(
                            with: geometry
                        )
                    }
                }
            } else {
                // BottomSheet header content
                if self.headerContent != nil || self.configuration.isCloseButtonShown {
                    self.header(
                        with: geometry
                    )
                }
                
                // BottomSheet main content
                if self.bottomSheetPosition.isBottom {
                    // In a bottom position the main content is hidden - add a Spacer to fill the height
                    Spacer(minLength: 0)
                        .frame(
                            height: self.bottomPositionSpacerHeight
                        )
                } else {
                    // Main content
                    self.bottomSheetContent(
                        with: geometry
                    )
                }
            }
            
            // Drag indicator for iPad and Mac
            if self.configuration.isResizeable && self.configuration.isDragIndicatorShown && self.isIPadOrMac {
                self.dragIndicator(
                    with: geometry
                )
            }
        }
        // Set the height and width to its calculated values
        // The content should be aligned to the top on iPhone
        // On iPad and Mac to the bottom
        .frame(
            width: self.width(
                with: geometry
            ),
            height: self.height(
                with: geometry
            ),
            alignment: self.isIPadOrMac ? .bottom : .top
        )
        // Get dynamic content size
        .background(
            GeometryReader { geometry in
                Color.clear
                    .onReceive(
                        Just(
                            self.bottomSheetPosition
                        )
                    ) { _ in
                        if !self.bottomSheetPosition.isDynamic {
                            // Reset contentHeight when not dynamic
                            self.contentHeight = nil
                        } else if self.translation == 0 {
                            // Update content height when dynamic and not dragging
                            self.contentHeight = geometry.size.height
                        }
                    }
            }
        )
        // BottomSheet background
        .background(
            Group {
                // Use custom BottomSheet background if set
                if let backgroundView = self.configuration.backgroundView {
                    backgroundView
                } else {
                    // Default BottomSheet background
                    VisualEffectView(
                        visualEffect: .system
                    )
                    // Add corner radius to BottomSheet background
                    // On iPhone only to the top corners
                    // On iPad and Mac to all corners
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
                    self.configuration.isResizeable ? self.dragGesture(
                        with: geometry
                    ) : nil
                )
        )
        // Clip BottomSheet so that all of the transition is hidden
        .clipped()
        // On iPad and Mac the BottomSheet has a padding to the edges
        .padding(
            self.isIPadOrMac ? 10 : 0
        )
        // Add safe area top padding on iPad and Mac
        .padding(
            .top,
            self.iPadAndMacTopPadding
        )
        // Make the BottomSheet transition via move
        .transition(
            .move(
                edge: self.isIPadOrMac ? .top : .bottom
            )
        )
    }
    
    func dragIndicator(
        with geometry: GeometryProxy
    ) -> some View {
        Button(
            action: {
                self.dragIndicatorAction(
                    with: geometry
                )
            },
            label: {
                Capsule()
                // Design of the drag indicator
                    .fill(
                        self.configuration.dragIndicatorColor
                    )
                    .frame(
                        width: 36,
                        height: 5
                    )
                    .padding(
                        .top,
                        5
                    )
                    .padding(
                        .bottom,
                        7
                    )
                // Make the drag indicator drag-able
                    .gesture(
                        self.dragGesture(
                            with: geometry
                        )
                    )
            })
        // Make it borderless for Mac
            .buttonStyle(.borderless)
    }
    
    func header(
        with geometry: GeometryProxy
    ) -> some View {
        HStack(
            alignment: .top,
            spacing: 0
        ) {
            // Header content
            if let headerContent = self.headerContent {
                headerContent
            }
            
            Spacer(
                minLength: 0
            )
            
            // Close button
            if self.configuration.isCloseButtonShown {
                self.closeButton
            }
        }
        // Add horizontal padding
        .padding(
            .horizontal
        )
        // Add top padding when on iPad or Mac or when the drag indicator is not shown
        .padding(
            .top,
            self.isIPadOrMac || !self.configuration.isDragIndicatorShown || !self.configuration.isResizeable ? 20 : 0
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
                    .onReceive(Just(self.configuration.isDragIndicatorShown)) { _ in
                        self.headerContentHeight = geometry.size.height
                    }
                    .onReceive(Just(self.configuration.isResizeable)) { _ in
                        self.headerContentHeight = geometry.size.height
                    }
                    .onReceive(Just(self.configuration.isCloseButtonShown)) { _ in
                        self.headerContentHeight = geometry.size.height
                    }
                    .onReceive(Just(self.headerContent)) { _ in
                        self.headerContentHeight = geometry.size.height
                    }
            }
        )
        // Make the header drag-able
        .gesture(
            self.configuration.isResizeable ? self.dragGesture(
                with: geometry
            ) : nil
        )
    }
    
    var closeButton: some View {
        Button(
            action: self.closeSheet
        ) {
            Image(
                "xmark.circle.fill",
                bundle: Bundle.module
            )
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
        }
        // Make it borderless for Mac
        .buttonStyle(.borderless)
    }
    
    func bottomSheetContent(
        with geometry: GeometryProxy
    ) -> some View {
        // TODO: Fix mainContent not disappearing correctly on iPad and Mac (due to header content)
        // VStack to make frame workaround work
        VStack(alignment: .center, spacing: 0) {
            if self.configuration.isAppleScrollBehaviorEnabled && self.configuration.isResizeable {
                // TODO: Fix appleScrollBehaviour not working when main content doesn't is higher or equal to BottomSheet height
                // Content for .appleScrollBehavior
                if self.isIPadOrMac {
                    ScrollView {
                        self.mainContent
                    }
                } else {
#if !os(macOS)
                    self.appleScrollView(
                        with: geometry
                    )
#endif
                }
            } else {
                // Normal Content
                self.mainContent
                // Make the main content drag-able if content drag is enabled
                    .gesture(
                        self.configuration.isContentDragEnabled && self.configuration.isResizeable ? self.dragGesture(
                            with: geometry
                        ) : nil
                    )
            }
        }
        // Align content correctly and make it fill all available space when not dynamic or iPad or Mac
        // This workaround fixes the transition
        .frame(
            maxWidth: .infinity,
            maxHeight: self.bottomSheetPosition.isDynamic || self.isIPadOrMac ? (
                self.height(with: geometry) != nil ? self.height(with: geometry)! - self.headerContentHeight : nil
            ) : .infinity,
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
        .transition(
            .move(
                edge: self.isIPadOrMac ? .top : .bottom
            )
        )
    }
    
#if !os(macOS)
    func appleScrollView(
        with geometry: GeometryProxy
    ) -> some View {
        UIScrollViewWrapper(
            isScrollEnabled: self.$isScrollEnabled,
            dragState: self.$dragState
        ) {
            self.mainContent
        }
        // Make ScrollView drag-able
        .gesture(
            self.isScrollEnabled ? nil : self.appleScrollViewDragGesture(
                with: geometry
            )
        )
    }
#endif
}
