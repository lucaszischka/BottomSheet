//
//  ViewExtension.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//

import SwiftUI

public extension View {
    /**
     A modifer to add a BottomSheet to your view.
     
     - Parameter bottomSheetPosition: A binding that saves the current state of the BottomSheet. This can be any `enum` that conforms to `CGFloat` and `CaseIterable`. For more information about custom enums see `BottomSheetPosition`.
     - Parameter options: An array that contains the settings / options for the BottomSheet. Can be `nil`. For more information about the possible options see `BottomSheet.Options`.
     - Parameter headerContent: A view that is used as header content for the BottomSheet. You can use a string that is used as the title for the BottomSheet instead.
     - Parameter mainContent: A view that is used as main content for the BottomSheet.
    */
    func bottomSheet<hContent: View, mContent: View, bottomSheetPositionEnum: RawRepresentable>(bottomSheetPosition: Binding<bottomSheetPositionEnum>, options: [BottomSheet.Options] =  [], @ViewBuilder headerContent: () -> hContent? = { return nil }, @ViewBuilder mainContent: () -> mContent) -> some View where bottomSheetPositionEnum.RawValue == CGFloat, bottomSheetPositionEnum: CaseIterable {
        ZStack {
            self
            BottomSheetView(bottomSheetPosition: bottomSheetPosition, options: options, headerContent: headerContent, mainContent: mainContent)
        }
    }
    
    /**
     A modifer to add a BottomSheet to your view.
     
     - Parameter bottomSheetPosition: A binding that saves the current state of the BottomSheet. This can be any `enum` that conforms to `CGFloat` and `CaseIterable`. For more information about custom enums see `BottomSheetPosition`.
     - Parameter options: An array that contains the settings / options for the BottomSheet. For more information about the possible options see `BottomSheet.Options`.
     - Parameter title: A string that is used as the title for the BottomSheet. Can be `nil`. You can use a view that is used as header content for the BottomSheet instead.
     - Parameter content: A view that is used as content for the BottomSheet.
    */
    func bottomSheet<mContent: View, bottomSheetPositionEnum: RawRepresentable>(bottomSheetPosition: Binding<bottomSheetPositionEnum>, options: [BottomSheet.Options] = [], title: String? = nil, @ViewBuilder content: () -> mContent) -> some View where bottomSheetPositionEnum.RawValue == CGFloat, bottomSheetPositionEnum: CaseIterable {
        ZStack {
            self
            BottomSheetView(bottomSheetPosition: bottomSheetPosition, options: options, title: title, content: content)
        }
    }
}
