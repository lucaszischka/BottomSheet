//
//  BottomSheetView+HelperViews.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

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
                // When bottom position the main content is hidden and add spacer to fill the height
                // For dynamic make the height match the bottom sava area
                Spacer(minLength: 0)
                    .frame(height: self.bottomSheetPosition.isDynamic ? geometry.safeAreaInsets.bottom : nil)
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
        // Ignore bottom safe area on iPhone
        .edgesIgnoringSafeArea(
            self.isIPadOrMac ? [] : .bottom
        )
        // Set the height and with to its calculated values
        // Align content to the bottom on iPad or Mac
        // Align content to the top on iPhone
        .frame(
            width: self.width(
                with: geometry
            ),
            height: self.height(
                with: geometry
            )/*,
            alignment: self.isIPadOrMac ? .bottom : .top*/
        )
        .background(
            // BottomSheet background
            self.configuration.backgroundView
//                .edgesIgnoringSafeArea(
//                    self.isIPadOrMac ? [] : .bottom
//                )
            // Make the background dragable
                .gesture(
                    self.configuration.isResizeable ? self.dragGesture(
                        with: geometry
                    ) : nil
                )
        )
        // TODO: Continue
//        .offset(
//            y: self.offsetY(
//                with: geometry
//            )
//        )
        .transition(
            .move(
                edge: .bottom
            )
        )
        // TODO: Redo dynamic?
        .measureSize { size in
            self.contentHeight = size.height
        }
        // On iPad and Mac the BottomSheet has a padding to the edges
        .padding(
            self.isIPadOrMac ? 10 : 0
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
                    .gesture(
                        self.dragGesture(
                            with: geometry
                        )
                    )
            })
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
        .gesture(
            self.configuration.isResizeable ? self.dragGesture(
                with: geometry
            ) : nil
        )
        .padding(
            .horizontal
        )
        // Add top padding when on iPad or Mac or when the drag indicator is not shown
        .padding(
            .top,
            self.configuration.isResizeable && self.configuration.isDragIndicatorShown && !self.isIPadOrMac ? 0 : 20
        )
        // TODO: Needed?
        .padding(
            .bottom,
            self.headerContentPadding(
                with: geometry
            )
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
        .buttonStyle(.borderless)
    }
    
    func bottomSheetContent(
        with geometry: GeometryProxy
    ) -> some View {
        Group {
            if self.configuration.isAppleScrollBehaviorEnabled && self.configuration.isResizeable {
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
                    .gesture(
                        self.configuration.isContentDragEnabled && self.configuration.isResizeable ? self.dragGesture(
                            with: geometry
                        ) : nil
                    )
            }
        }
        // Clip content to avoid that it leavs the BottomSheet
        .clipped()
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
        .gesture(
            self.isScrollEnabled ? nil : self.appleScrollViewDragGesture(
                with: geometry
            )
        )
    }
#endif
}
