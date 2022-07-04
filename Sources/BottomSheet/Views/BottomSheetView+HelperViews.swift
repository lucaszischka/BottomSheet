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
                self.configuration.onDragChanged(
                    value
                )
                
                self.translation = self.isIPadOrMac ? -value.translation.height : value.translation.height
                self.endEditing()
            }
            .onEnded { value in
                self.configuration.onDragEnded(
                    value
                )
                
                self.switchPosition(
                    with: geometry,
                    translation: self.isIPadOrMac ? -value.translation.height : value.translation.height
                )
                
                self.translation = 0
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
                    self.dragState = .changed(
                        value: value
                    )
                    self.translation = 0
                } else {
                    self.dragState = .none
                    self.translation = self.isIPadOrMac ? -value.translation.height : value.translation.height
                }
                
                self.endEditing()
            }
            .onEnded { value in
                if value.translation.height < 0 && self.bottomSheetPosition.isTop {
                    self.dragState = .ended(
                        value: value
                    )
                    self.translation = 0
                    self.isScrollEnabled = true
                } else {
                    self.dragState = .none
                    self.switchPosition(
                        with: geometry,
                        translation: self.isIPadOrMac ? -value.translation.height : value.translation.height
                    )
                    
                    self.translation = 0
                }
                
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
                self.opacity(
                    with: geometry
                )
            )
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
            .edgesIgnoringSafeArea(
                .all
            )
            .contentShape(
                Rectangle()
            )
            .allowsHitTesting(
                self.configuration.isTapToDismissEnabled
            )
            .onTapGesture(
                perform: self.tapToDismissAction
            )
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
            // Drag indicator - iPhone
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
            if !self.bottomSheetPosition.isBottom {
                self.bottomSheetContent(
                    with: geometry
                )
            } else {
                Color.clear
            }
            
            // Drag indicator - iPad and Mac
            if self.configuration.isResizeable && self.configuration.isDragIndicatorShown && self.isIPadOrMac {
                self.dragIndicator(
                    with: geometry
                )
            }
        }
        .edgesIgnoringSafeArea(
            self.isIPadOrMac ? [] : .bottom
        )
        .frame(
            width: self.width(
                with: geometry
            ),
            height: self.height(
                with: geometry
            ),
            alignment: self.isIPadOrMac ? .bottom : .top
        )
        .background(
            // BottomSheet background
            self.configuration.backgroundView
                .edgesIgnoringSafeArea(
                    self.isIPadOrMac ? [] : .bottom
                )
                .gesture(
                    self.configuration.isResizeable ? self.dragGesture(
                        with: geometry
                    ) : nil
                )
        )
        .offset(
            y: self.offsetY(
                with: geometry
            )
        )
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
        .padding(
            .top,
            self.configuration.isResizeable && self.configuration.isDragIndicatorShown && !self.isIPadOrMac ? 0 : 20
        )
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
                "xmark.circle.fill"
            )
        }
        .buttonStyle(.borderless)
        .font(
            .title
        )
    }
    
    func bottomSheetContent(
        with geometry: GeometryProxy
    ) -> some View {
        Group {
            if self.configuration.isAppleScrollBehaviorEnabled && self.configuration.isResizeable && !self.isIPadOrMac {
                // Content for .appleScrollBehavior
#if !os(macOS)
                self.appleScrollView(
                    with: geometry
                )
#endif
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
        .gesture(
            self.isScrollEnabled ? nil : self.appleScrollViewDragGesture(
                with: geometry
            )
        )
    }
#endif
}
