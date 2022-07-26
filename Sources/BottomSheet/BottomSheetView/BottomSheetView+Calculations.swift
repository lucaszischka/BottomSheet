//
//  BottomSheetView+Calculations.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

internal extension BottomSheetView {
    
    // For iPad and Mac support
    var isIPadOrMac: Bool {
#if os(macOS)
        return true
#else
        if self.horizontalSizeClass == .regular && self.verticalSizeClass == .regular {
            return true
        } else {
            return false
        }
#endif
    }
    
    var iPadAndMacTopPadding: CGFloat {
        if self.isIPadOrMac {
#if !os(macOS)
            return UIApplication.shared.windows.first?.safeAreaInsets.top ?? 10
#else
            return NSApplication.shared.mainMenu?.menuBarHeight ?? 20
#endif
        } else {
            return 0
        }
    }
    
    // For views and calculations
    var bottomPositionSpacerHeight: CGFloat? {
        if self.bottomSheetPosition.isDynamic {
            if self.isIPadOrMac {
                // When dynamic make Spacer have no height (iPad and Mac)
                return 0
            } else {
#if !os(macOS)
                // When dynamic make Spacer have bottom safe area as height (iPhone)
                return UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 20
#else
                // Should never be called
                return 0
#endif
            }
        } else {
            // Let it take up all space
            return nil
        }
    }
    
    func maxBottomSheetHeight(with geometry: GeometryProxy) -> CGFloat {
        return geometry.size.height - (self.isIPadOrMac ? 20 : 0) - self.iPadAndMacTopPadding
    }
    
    func currentBottomSheetHeight(with geometry: GeometryProxy) -> CGFloat {
        switch self.bottomSheetPosition {
        case .hidden:
            return 0
        case .dynamic, .dynamicTop, .dynamicBottom:
            return self.mainContentHeight + self.headerContentHeight + (self.configuration.isResizable && self.configuration.isDragIndicatorShown ? 20 : 0)
        case .relative(let value), .relativeBottom(let value), .relativeTop(let value):
            return self.maxBottomSheetHeight(with: geometry) * value
        case .absolute(let value), .absoluteBottom(let value), .absoluteTop(let value):
            return value
        }
    }
    
    // For `endEditing`
    func endEditing() {
#if !os(macOS)
        UIApplication.shared.endEditing()
#endif
    }
    
    // For `backgroundBlur`
    func opacity(with geometry: GeometryProxy) -> Double {
        if self.configuration.isBackgroundBlurEnabled {
            // Calculate background blur relative to BottomSheet height
            return min(
                max(
                    Double(
                        (self.currentBottomSheetHeight(with: geometry) - self.translation) / (self.maxBottomSheetHeight(with: geometry))
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
    func width(with geometry: GeometryProxy) -> CGFloat {
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
    func height(with geometry: GeometryProxy) -> CGFloat {
        // Calculate BottomSheet height by subtracting translation
        return min(
            max(
                self.currentBottomSheetHeight(with: geometry) - self.translation,
                self.headerContentHeight
            ),
            self.maxBottomSheetHeight(with: geometry)
        )
    }
    
    // For iPad and Mac
    func maxMainContentHeight(
        with geometry: GeometryProxy
    ) -> CGFloat {
        // The max height of the main content is the height of the BottomSheet
        // without the header and drag indicator
        // TODO: Do i need to user self.height()?
        return max(
            self.height(with: geometry) - self.headerContentHeight - (self.configuration.isResizable && self.configuration.isDragIndicatorShown ? 20 : 0),
            0
        )
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
            if let height = position.asScreenHeight(with: self.maxBottomSheetHeight(with: geometry)) {
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
