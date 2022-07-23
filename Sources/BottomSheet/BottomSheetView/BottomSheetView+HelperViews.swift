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
                    // Notifiy the ScrollView that the user switched to scrolling
                    self.dragState = .changed(
                        value: value
                    )
                    // Reset translation, because the user switched to scrolling
                    self.translation = 0
                } else {
                    // Perform custom action from the user
                    self.configuration.onDragChanged(
                        value
                    )
                    
                    // Notifiy the ScrollView that the user switched to dragging
                    self.dragState = .none
                    // Update translation; on iPad and Mac the drag direction is reversed
                    self.translation = self.isIPadOrMac ? -value.translation.height : value.translation.height
                }
                
                // Dismiss the keyboard on drag/scroll
                self.endEditing()
            }
            .onEnded { value in
                if value.translation.height < 0 && self.bottomSheetPosition.isTop {
                    // Notifiy the ScrollView that the user ended to scrolling
                    self.dragState = .ended(
                        value: value
                    )
                    // Reset translation, because the user ended to scrolling
                    self.translation = 0
                    // Enable further interaction via the ScrollView directly
                    self.isScrollEnabled = true
                } else {
                    // Perform custom action from the user
                    self.configuration.onDragEnded(
                        value
                    )
                    
                    // Notifiy the ScrollView that the user switched to dragging
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
        self.configuration.backgroundBlurMaterial
            .opacity(
                // When .backgroundBlur is enabled the opacity is calculated
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
        // Make the background tapable
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
            // Drag indicator for iPhone
            if self.configuration.isResizeable && self.configuration.isDragIndicatorShown && !self.isIPadOrMac {
                self.dragIndicator(
                    with: geometry
                )
            }
            
            // BottomSheet header content
            if self.headerContent != nil || self.configuration.isCloseButtonShown {
                self.header(
                    with: geometry
                )
            }
            
            // BottomSheet main content
            if self.bottomSheetPosition.isBottom {
                // In a bottom position the main content is hidden - add a Spacer to fill the set height
                // For .dynamicBottom make the height match the bottom sava area
                Spacer(minLength: 0)
                    .frame(height: self.bottomSheetPosition.isDynamic ? (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 20) : nil)
            } else {
                // Main content
                self.bottomSheetContent(
                    with: geometry
                )
            }
            
            // Drag indicator for iPad and Mac
            if self.configuration.isResizeable && self.configuration.isDragIndicatorShown && self.isIPadOrMac {
                self.dragIndicator(
                    with: geometry
                )
            }
        }
        // Set the height and with to its calculated values
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
                    .onReceive(Just(self.bottomSheetPosition)) { _ in
                        // Don't update on drag and when not dynamic
                        if !self.bottomSheetPosition.isDynamic {
                            self.contentHeight = nil
                        } else if self.translation == 0 {
                            self.contentHeight = geometry.size.height
                        }
                    }
            }
        )
        // TODO: Fix background not transitioning via move
        // BottomSheet background
        .background(
            self.configuration.backgroundView
            // Make the background dragable
                .gesture(
                    self.configuration.isResizeable ? self.dragGesture(
                        with: geometry
                    ) : nil
                )
        )
        // On iPad and Mac the BottomSheet has a padding to the edges
        .padding(
            self.isIPadOrMac ? 10 : 0
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
                // Make the drag indicator dragable
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
        // Make the header dragable
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
        // VStack to make frame workaround work
        VStack(alignment: .center, spacing: 0) {
            if self.configuration.isAppleScrollBehaviorEnabled && self.configuration.isResizeable {
                // TODO: Fix appleScrollBehaviour not working when main content doesnt fill BottomSheet
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
                // Make the main content dragable if content drag is enabled
                    .gesture(
                        self.configuration.isContentDragEnabled && self.configuration.isResizeable ? self.dragGesture(
                            with: geometry
                        ) : nil
                    )
            }
            
            if !self.bottomSheetPosition.isDynamic {
                Spacer(minLength: 0)
            }
        }
//        // Align content to top and make it fill all avaiable space when not dynamic
//        // This workaround fixes the transition
//        .frame(
//            maxWidth: self.bottomSheetPosition.isDynamic ? nil : .infinity,
//            maxHeight: self.bottomSheetPosition.isDynamic ? nil : .infinity,
//            alignment: .top
//        )
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
        // Make ScrollView dragable
        .gesture(
            self.isScrollEnabled ? nil : self.appleScrollViewDragGesture(
                with: geometry
            )
        )
    }
#endif
}
