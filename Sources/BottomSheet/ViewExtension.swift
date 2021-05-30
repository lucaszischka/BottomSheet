//
//  ViewExtension.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//

import SwiftUI

public extension View {
    /**
     A modifer to add an BottomSheet to your view.
     
     - Parameter bottomSheetPosition: An Binding containing the state of the BottomSheet. This can be any `enum` conforming to `CGFloat` and `CaseIterable`. For more info see `BottomSheetPosition`
     - Parameter options: An Array containing the settings / options for the BottomSheet. For more info see `BottomSheet.Options`
     - Parameter headerContent: An View used as header content for the BottomSheet
     - Parameter content: An View used as main content for the BottomSheet
    */
    func bottomSheet<hContent: View, mContent: View, bottomSheetPositionEnum: RawRepresentable>(bottomSheetPosition: Binding<bottomSheetPositionEnum>, options: [BottomSheet.Options] =  [], @ViewBuilder headerContent: () -> hContent? = { return nil }, @ViewBuilder mainContent: () -> mContent) -> some View where bottomSheetPositionEnum.RawValue == CGFloat, bottomSheetPositionEnum: CaseIterable {
        ZStack {
            self
            BottomSheetView(bottomSheetPosition: bottomSheetPosition, options: options, headerContent: headerContent, mainContent: mainContent)
        }
    }
    
    /**
     A modifer to add an BottomSheet to your view.
     
     - Parameter bottomSheetPosition: An Binding containing the state of the BottomSheet. This can be any `enum` conforming to `CGFloat` and `CaseIterable`. For more info see `BottomSheetPosition`
     - Parameter options: An Array containing the settings / options for the BottomSheet. For more info see `BottomSheet.Options`
     - Parameter title: An String used as title for the BottomSheet
     - Parameter content: An View used as content for the BottomSheet
    */
    func bottomSheet<mContent: View, bottomSheetPositionEnum: RawRepresentable>(bottomSheetPosition: Binding<bottomSheetPositionEnum>, options: [BottomSheet.Options] = [], title: String? = nil, @ViewBuilder content: () -> mContent) -> some View where bottomSheetPositionEnum.RawValue == CGFloat, bottomSheetPositionEnum: CaseIterable {
        ZStack {
            self
            BottomSheetView(bottomSheetPosition: bottomSheetPosition, options: options, title: title, content: content)
        }
    }
}
