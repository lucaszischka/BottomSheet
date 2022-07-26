//
//  BottomSheetView+Calculations.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

internal extension BottomSheetView {
    // For `endEditing`
    func endEditing() {
#if !os(macOS)
        UIApplication.shared.endEditing()
#endif
    }
    
    // For `backgroundBlur`
    func opacity(
        with geometry: GeometryProxy
    ) -> Double {
        // The height of the currentBottomSheetPosition; if nil use content height
        let height = self.bottomSheetPosition.asScreenHeight(
            with: geometry
        ) ?? self.contentHeight
        
        if let height = height, self.configuration.isBackgroundBlurEnabled {
            // Calculate background blur relative to BottomSheet height
            return min(
                max(
                    Double(
                        (height - self.translation) / (
                            geometry.size.height - (self.isIPadOrMac ? 20 : 0) - self.iPadAndMacTopPadding
                        )
                    ),
                    0
                ),
                1
            )
        } else {
            // Should never be called
            return 0
        }
    }
    
    // For `tapToDismiss`
    func tapToDismissAction() {
        // Only dismiss sheet when `tapToDismiss` is enabled
        if self.configuration.isTapToDismissEnabled {
            self.closeSheet()
        }
    }
    
    // For closing the sheet
    func closeSheet() {
        self.bottomSheetPosition = .hidden
        self.endEditing()
        
        self.configuration.onDismiss()
    }
    
    // For iPhone landscape, iPad and Mac support
    func width(
        with geometry: GeometryProxy
    ) -> CGFloat {
#if os(macOS)
        // On Mac use 30% of the width
        return geometry.size.width * 0.3
#else
        if self.isIPadOrMac {
            // On iPad use 30% of the width
            return geometry.size.width * 0.3
        } else if UIDevice.current.orientation.isLandscape {
            // On iPhone landscape use of the 40% width
            return geometry.size.width * 0.4
        } else {
            // On iPhone portrait use of the 100% width
            return geometry.size.width
        }
#endif
    }
    
    // For `bottomSheetPosition`
    func height(
        with geometry: GeometryProxy
    ) -> CGFloat? {
        // The height of the currentBottomSheetPosition; if nil and dragging use content height
        let height = self.bottomSheetPosition.asScreenHeight(
            with: geometry
        ) ?? (self.translation == 0 ? nil : self.contentHeight)
        
        if let height = height {
            // Calculate BottomSheet height by subtracting translation
            return min(
                max(
                    height - self.translation,
                    0
                ),
                // Subtract potential padding
                geometry.size.height - (self.isIPadOrMac ? 20 : 0) - self.iPadAndMacTopPadding
            )
        } else {
            // TODO: Fix dynamic leaving screen on iPad and Mac
            // Use nil if `.dynamic...` and currently not dragging
            return nil
        }
    }
    
    // For iPad and Mac
    func maxMainContentHeight(
        with geometry: GeometryProxy
    ) -> CGFloat {
        // The height of the BottomSheet
        if let height = self.height(with: geometry) {
            // The max height of the main content is the height of the BottomSheet
            // without the header and drag indicator
            return height - self.headerContentHeight - (self.configuration.isDragIndicatorShown ? 20 : 0)
        } else {
            // If dynamic the max height of the main content is the height of the screen
            // without the padding
            return geometry.size.height - (self.isIPadOrMac ? 20 : 0) - self.iPadAndMacTopPadding
        }
    }
    
    // For position switching
    func getSwitchablePositions(
        with geometry: GeometryProxy
    ) -> [(
        height: CGFloat,
        position: BottomSheetPosition
    )] {
        return self.switchablePositions.compactMap({ (position) -> (height: CGFloat,
                                                                    position: BottomSheetPosition)? in
            if let height = position.asScreenHeight(
                with: geometry
            ) {
                if position.isHidden || position == self.bottomSheetPosition {
                    // Remove hidden and current position
                    return nil
                } else {
                    return (
                        height: height,
                        position: position
                    )
                }
            } else {
                // Remove `.dynamic...` positions
                return nil
            }
        }).sorted(by: {
            // Sort by height (low to high)
            $0.height < $1.height
        })
    }
}
