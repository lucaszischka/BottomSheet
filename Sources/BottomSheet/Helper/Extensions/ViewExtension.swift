//
//  ViewExtension.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

public extension View {
    
    /// Adds a BottomSheet to the view.
    ///
    /// - Parameter bottomSheetPosition: A binding that holds the current position.
    /// For more information about the possible positions see  `BottomSheetPosition`.
    /// - Parameter switchablePositions: An array that contains the positions for the BottomSheet.
    /// Only the positions contained in the array can be switched into (via drag indicator or swipe).
    /// - Parameter headerContent: A view that is used as header content for the BottomSheet.
    /// You can use a text that is displayed as title instead.
    /// - Parameter mainContent: A view that is used as main content for the BottomSheet.
    func bottomSheet<HContent: View, MContent: View>(
        bottomSheetPosition: Binding<BottomSheetPosition>,
        switchablePositions: [BottomSheetPosition],
        @ViewBuilder headerContent: () -> HContent? = {
            return nil
        },
        @ViewBuilder mainContent: () -> MContent
    ) -> BottomSheet<HContent, MContent, Self> {
        BottomSheet(
            bottomSheetPosition: bottomSheetPosition,
            switchablePositions: switchablePositions,
            headerContent: headerContent(),
            mainContent: mainContent(),
            view: self
        )
    }
    
    /// Adds a BottomSheet to the view.
    ///
    /// - Parameter bottomSheetPosition: A binding that holds the current position.
    /// For more information about the possible positions see  `BottomSheetPosition`.
    /// - Parameter switchablePositions: An array that contains the positions for the BottomSheet.
    /// Only the positions contained in the array can be switched into (via drag indicator or swipe).
    /// - Parameter title: You can use a text that is displayed as title instead.
    /// A view that is used as header content for the BottomSheet.
    /// - Parameter content: A view that is used as main content for the BottomSheet.
    typealias TitleContent = ModifiedContent<ModifiedContent<Text,
                                                             _EnvironmentKeyWritingModifier<Int?>>, _PaddingLayout>
    
    func bottomSheet<MContent: View>(
        bottomSheetPosition: Binding<BottomSheetPosition>,
        switchablePositions: [BottomSheetPosition],
        title: String? = nil,
        @ViewBuilder content: () -> MContent
    ) -> BottomSheet<TitleContent, MContent, Self> {
        BottomSheet(
            bottomSheetPosition: bottomSheetPosition,
            switchablePositions: switchablePositions,
            title: title,
            content: content(),
            view: self
        )
    }
}
