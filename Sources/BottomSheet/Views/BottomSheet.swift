//
//  BottomSheet.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

public struct BottomSheet<HContent: View, MContent: View, V: View>: View {
    
    @Binding private var bottomSheetPosition: BottomSheetPosition
    
    // Views
    private let view: V
    private let headerContent: HContent?
    private let mainContent: MContent
    
    private let switchablePositions: [BottomSheetPosition]
    
    // Configuration
    internal let configuration: BottomSheetConfiguration = BottomSheetConfiguration()
    
    public var body: some View {
        // ZStack for creating the overlay on the original view
        ZStack {
            self.view
            
            BottomSheetView(
                bottomSheetPosition: self.$bottomSheetPosition,
                headerContent: self.headerContent,
                mainContent: self.mainContent,
                switchablePositions: self.switchablePositions,
                configuration: self.configuration
            )
        }
    }
    
    // Initializers
    internal init(
        bottomSheetPosition: Binding<BottomSheetPosition>,
        switchablePositions: [BottomSheetPosition],
        headerContent: HContent?,
        mainContent: MContent,
        view: V
    ) {
        self._bottomSheetPosition = bottomSheetPosition
        self.switchablePositions = switchablePositions
        self.headerContent = headerContent
        self.mainContent = mainContent
        self.view = view
    }
    
    internal init(
        bottomSheetPosition: Binding<BottomSheetPosition>,
        switchablePositions: [BottomSheetPosition],
        title: String?,
        content: MContent,
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
            }(),
            mainContent: content,
            view: view
        )
    }
}
