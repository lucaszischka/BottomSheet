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
        if self.configuration.isBackgroundBlurEnabled {
            // Calculate background blur relative to BottomSheet height
            let height = self.bottomSheetPosition.asScreenHeight(
                with: geometry
            ) ?? self.contentHeight
            return Double(
                (height - self.translation) / geometry.size.height
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
    
    // For `headerContent`
    func headerContentPadding(
        with geometry: GeometryProxy
    ) -> CGFloat {
        // If no header content (thus no padding) add it automatically
        if self.headerContent == nil {
            return 20
        } else if self.bottomSheetPosition.isDynamic {
            // TODO: Reason?
            return 0
        } else {
            // TODO: Reason?
            return 0
        }
    }
    
    // For `landscape`, `iPad` and `Mac` support
    func width(
        with geometry: GeometryProxy
    ) -> CGFloat {
#if os(macOS)
        return geometry.size.width * 0.3
#else
        if self.horizontalSizeClass == .regular {
            return geometry.size.width * 0.3
        } else {
            return geometry.size.width
        }
#endif
    }
    
    // For `bottomSheetPosition`
    func height(
        with geometry: GeometryProxy
    ) -> CGFloat? {
        if let height = self.bottomSheetPosition.asScreenHeight(
            with: geometry
        ) {
            return min(
                max(
                    height - self.translation,
                    0
                ),
                geometry.size.height * 1.05
            )
        } else {
            // Is .dynamic... so there is no fixed height
            return nil
        }
    }
    
    // For `bottomSheetPosition`
    func offsetY(
        with geometry: GeometryProxy
    ) -> Double {
        if self.isIPadOrMac {
            // No offset on Mac or iPad because it is dragged down not up
            return 0
        } else {
            let height = self.bottomSheetPosition.asScreenHeight(
                with: geometry
            ) ?? self.contentHeight
            
            if self.bottomSheetPosition.isHidden {
                // Move BottomSheet out of the screen
                return max(
                    geometry.size.height + geometry.safeAreaInsets.bottom,
                    geometry.size.height * -0.05
                )
            } else if self.bottomSheetPosition.isBottom {
                // TODO: Check reason?
                return max(
                    geometry.size.height - height +
                    self.translation + geometry.safeAreaInsets.bottom,
                    geometry.size.height * -0.05
                )
            } else {
                return max(
                    geometry.size.height - height +
                    self.translation,
                    geometry.size.height * -0.05
                )
            }
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
                if position.isHidden {
                    // Remove hidden position
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
