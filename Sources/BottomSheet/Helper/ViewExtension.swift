//
//  ViewExtension.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021-2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

public extension View {
    /**
     A modifer to add a BottomSheet to your view.
     
     - Parameter bottomSheetPosition: A binding that saves the current state of the BottomSheet.
     This can be any `enum` that conforms to `CGFloat`, `CaseIterable` and `Equatable`.
     For more information about custom enums see `BottomSheetPosition`.
     - Parameter options: An array that contains the settings / options for the BottomSheet.
     Can be `nil`. For more information about the possible options see `BottomSheet.Options`.
     - Parameter headerContent: A view that is used as header content for the BottomSheet.
     You can use a string that is used as the title for the BottomSheet instead.
     - Parameter mainContent: A view that is used as main content for the BottomSheet.
     */
    func bottomSheet<HContent: View,
                     MContent: View,
                     BottomSheetPositionEnum: RawRepresentable>(bottomSheetPosition: Binding<BottomSheetPositionEnum>,
                                                                options: [BottomSheet.Options] =  [],
                                                                @ViewBuilder headerContent: () -> HContent? = { return nil },
                                                                @ViewBuilder mainContent: () -> MContent) -> some View
    where BottomSheetPositionEnum.RawValue == CGFloat,
          BottomSheetPositionEnum: CaseIterable,
          BottomSheetPositionEnum: Equatable {
              ZStack {
                  self
                  BottomSheetView(bottomSheetPosition: bottomSheetPosition,
                                  options: options,
                                  headerContent: headerContent,
                                  mainContent: mainContent)
              }
          }
    
    /**
     A modifer to add a BottomSheet to your view.
     
     - Parameter bottomSheetPosition: A binding that saves the current state of the BottomSheet.
     This can be any `enum` that conforms to `CGFloat`, `CaseIterable` and `Equatable`.
     For more information about custom enums see `BottomSheetPosition`.
     - Parameter options: An array that contains the settings / options for the BottomSheet.
     For more information about the possible options see `BottomSheet.Options`.
     - Parameter title: A string that is used as the title for the BottomSheet.
     Can be `nil`. You can use a view that is used as header content for the BottomSheet instead.
     - Parameter content: A view that is used as content for the BottomSheet.
     */
    func bottomSheet<MContent: View,
                     BottomSheetPositionEnum: RawRepresentable>(bottomSheetPosition: Binding<BottomSheetPositionEnum>,
                                                                options: [BottomSheet.Options] = [],
                                                                title: String? = nil,
                                                                @ViewBuilder content: () -> MContent) -> some View
    where BottomSheetPositionEnum.RawValue == CGFloat,
          BottomSheetPositionEnum: CaseIterable,
          BottomSheetPositionEnum: Equatable {
              ZStack {
                  self
                  BottomSheetView(bottomSheetPosition: bottomSheetPosition,
                                  options: options,
                                  title: title,
                                  content: content)
              }
          }
}
