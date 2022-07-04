//
//  ViewExtension.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

public extension View {
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
