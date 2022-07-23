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
                        (height - self.translation) / geometry.size.height
                    ),
                    0
                ),
                1
            )
        } else {
            return 0
        }
    }
    
    // For `tapToDismiss`
    func tapToDismissAction() {
        if self.configuration.isTapToDismissEnabled {
            self.closeSheet()
        }
    }
    
    // General usage
    func closeSheet() {
        self.bottomSheetPosition = .hidden
        self.endEditing()
        
        self.configuration.onDismiss()
    }
    
    // For `landscape`, `iPad` and `Mac` support
    func width(
        with geometry: GeometryProxy
    ) -> CGFloat {
#if os(macOS)
        return geometry.size.width * 0.3
#else
        if self.isIPadOrMac || UIDevice.current.orientation.isLandscape {
            return geometry.size.width * 0.4
        } else {
            return geometry.size.width
        }
#endif
    }
    
    // For `bottomSheetPosition`
    func height(
        with geometry: GeometryProxy
    ) -> CGFloat? {
        // The height of the currentBottomSheetPosition; if nil and not dragging use content height
        let height = self.bottomSheetPosition.asScreenHeight(
            with: geometry
        ) ?? (self.translation != 0 ? self.contentHeight : nil)
        
        if let height = height {
            // Calculate BottomSheet height
            return min(
                max(
                    height - self.translation,
                    0
                ),
                geometry.size.height + geometry.safeAreaInsets.bottom
            )
        } else {
            // Use nil if dynamic and currently not dragging
            return nil
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
                // It as a .dynamic... position. Those are not included
                return nil
            }
        }).sorted(by: {
            // Sort by height (low to high)
            $0.height < $1.height
        })
    }
}
