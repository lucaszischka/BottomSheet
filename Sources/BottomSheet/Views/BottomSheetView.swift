//
//  BottomSheetView.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

public struct BottomSheetView<HContent: View, MContent: View, V: View>: View {
    
    // For `landscape`, `iPad`, `Mac` and `Tv` support
#if !os(macOS)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
#endif
    
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
    
    // For `appleScrollBehaviour`
    @State var isScrollEnabled: Bool = false
#if !os(macOS)
    @State var dragState: DragGesture.DragState = .none
#endif
    
    // Views
    let view: V
    let headerContent: HContent?
    let mainContent: MContent
    
    let switchablePositions: [BottomSheetPosition]
    
    // Configuration
    public let configuration: Configuration = Configuration()
    
    public var body: some View {
        // ZStack for creating the overlay on the original view
        ZStack {
            self.view
            
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
                        .measureSize { size in
                            self.contentHeight = size.height
                        }
                        .padding(self.isIPadOrMac ? 10 : 0)
                        .clipped()
                }
            }
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
                value: self.configuration
            )
            .animation(
                self.configuration.animation,
                value: self.isScrollEnabled
            )
        }
    }
    
    // Initializers
    init(
        bottomSheetPosition: Binding<BottomSheetPosition>,
        switchablePositions: [BottomSheetPosition],
        headerContent: () -> HContent?,
        mainContent: () -> MContent,
        view: V
    ) {
        self._bottomSheetPosition = bottomSheetPosition
        self.switchablePositions = switchablePositions
        self.headerContent = headerContent()
        self.mainContent = mainContent()
        self.view = view
    }
    
    init(
        bottomSheetPosition: Binding<BottomSheetPosition>,
        switchablePositions: [BottomSheetPosition],
        title: String?,
        content: () -> MContent,
        view: V
    ) {
        self.init(
            bottomSheetPosition: bottomSheetPosition,
            switchablePositions: switchablePositions,
            headerContent: {
                if let title = title {
                    return Text(title)
                        .font(
                            .title
                        )
                        .bold()
                        .lineLimit(
                            1
                        )
                        .padding(
                            .bottom
                        )
                    as? HContent
                } else {
                    return nil
                }
            },
            mainContent: content,
            view: view
        )
    }
}
