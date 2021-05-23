//
//  ViewExtension.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//

import SwiftUI

public extension View {
    func bottomSheet<hContent: View, mContent: View, bottomSheetPositionEnum: RawRepresentable>(bottomSheetPosition: Binding<bottomSheetPositionEnum>, options: [BottomSheet.Options], @ViewBuilder headerContent: () -> hContent?, @ViewBuilder mainContent: () -> mContent) -> some View where bottomSheetPositionEnum.RawValue == CGFloat, bottomSheetPositionEnum: CaseIterable {
        ZStack {
            self
            BottomSheetView(bottomSheetPosition: bottomSheetPosition, options: options, headerContent: headerContent, mainContent: mainContent)
        }
    }
    
    func bottomSheet<mContent: View, bottomSheetPositionEnum: RawRepresentable>(bottomSheetPosition: Binding<bottomSheetPositionEnum>, options: [BottomSheet.Options], title: String? = nil, @ViewBuilder content: () -> mContent) -> some View where bottomSheetPositionEnum.RawValue == CGFloat, bottomSheetPositionEnum: CaseIterable {
        ZStack {
            self
            BottomSheetView(bottomSheetPosition: bottomSheetPosition, options: options, title: title, content: content)
        }
    }
}
