//
//  BottomSheetView+Calculations.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

internal extension BottomSheetView {
    
    var isIPad: Bool {
#if os(macOS)
        return false
#else
        return self.horizontalSizeClass == .regular && self.verticalSizeClass == .regular
#endif
    }
    
    var isMac: Bool {
#if os(macOS)
        return true
#else
        return false
#endif
    }
    
    var isIPadOrMac: Bool {
        return self.isIPad || self.isMac
    }
    
    var isIPadFloating: Bool {
        return self.isIPad && self.configuration.iPadFloatingSheet
    }
    
    var isIPadFloatingOrMac: Bool {
        return self.isIPadFloating || self.isMac
    }
    
    /// Determines if the iPad sheet alignment is top-based (top, topLeading, topTrailing)
    var isIPadSheetAlignmentTop: Bool {
        switch self.configuration.iPadSheetAlignment {
        case .top, .topLeading, .topTrailing:
            return true
        default:
            return false
        }
    }
    
    var isIPadBottom: Bool {
        return self.isIPad && !self.configuration.iPadFloatingSheet
    }
    
    var topPadding: CGFloat {
        if self.isIPadFloatingOrMac {
#if os(macOS)
            return NSApplication.shared.mainMenu?.menuBarHeight ?? 20
#else
            return UIApplication.shared.windows.first?.safeAreaInsets.top ?? 10
#endif
        } else {
            return 0
        }
    }
    
    // Whether the header is a title
    var isTitleAsHeaderContent: Bool {
        return self.headerContent is ModifiedContent<Text, _EnvironmentKeyWritingModifier<Int?>>
    }
    
    // The height of the spacer when position is bottom
    var bottomPositionSpacerHeight: CGFloat? {
        // Only limit height when dynamic
        if self.bottomSheetPosition.isDynamic {
            // When dynamic return safe area and header height
            return self.bottomPositionSafeAreaHeight + self.headerContentHeight
        } else {
            // When not dynamic let it take all available space
            return nil
        }
    }
    
    // The height of the safe area when position is bottom
    var bottomPositionSafeAreaHeight: CGFloat {
        // Only add safe area when `dynamicBottom` and not on iPad floating or Mac
        if self.bottomSheetPosition == .dynamicBottom && !self.isIPadFloatingOrMac {
#if !os(macOS)
            // Safe area as height (iPhone)
            return UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 20
#else
            // Should never be called
            return 0
#endif
        } else {
            // When not `.dynamicBottom` or when iPad floating or Mac don't add safe area
            return 0
        }
    }
    
    // The minimum height of the BottomSheet
    var minBottomSheetHeight: CGFloat {
        // Header content and drag indicator height
        return self.headerContentHeight + (
            self.configuration.isResizable && self.configuration.isDragIndicatorShown ? 20 : 0
        )
    }
    
    // The maximum height of the BottomSheet
    func maxBottomSheetHeight(with geometry: GeometryProxy) -> CGFloat {
        // Screen height without safe areas and padding
        return geometry.size.height - (self.isIPadFloatingOrMac ? 20 : 0) - self.topPadding
    }
    
    // The current height of the BottomSheet (without translation)
    func currentBottomSheetHeight(with geometry: GeometryProxy) -> CGFloat {
        switch self.bottomSheetPosition {
        case .hidden:
            return 0
        case .dynamic, .dynamicTop, .dynamicBottom:
            // Main content, header content and drag indicator height
            return self.dynamicMainContentHeight + self.headerContentHeight + (
                self.configuration.isResizable && self.configuration.isDragIndicatorShown ? 20 : 0
            )
        case .relative(let value), .relativeBottom(let value), .relativeTop(let value):
            // Percentage of the max height
            return self.maxBottomSheetHeight(with: geometry) * value
        case .absolute(let value), .absoluteBottom(let value), .absoluteTop(let value):
            return value
        }
    }
    
    // For iPad and Mac
    func maxMainContentHeight(with geometry: GeometryProxy) -> CGFloat? {
        if self.bottomSheetPosition.isDynamic && self.dynamicMainContentHeight < max(
            self.maxBottomSheetHeight(with: geometry) - self.translation - self.headerContentHeight - (
                self.configuration.isResizable && self.configuration.isDragIndicatorShown ? 20 : 0
            ),
            0
        ) {
            // Let dynamic content take all space it wants, as long as it is smaller than the allowed height
            return nil
        } else {
            // The max height of the main content is the height of the BottomSheet
            // without the header and drag indicator
            return max(
                self.height(with: geometry) - self.headerContentHeight - (
                    self.configuration.isResizable && self.configuration.isDragIndicatorShown ? 20 : 0
                ),
                0
            )
        }
    }
    
    // For `bottomSheetPosition`
    func height(with geometry: GeometryProxy) -> CGFloat {
        // Calculate BottomSheet height by subtracting translation
        return min(
            max(
                self.currentBottomSheetHeight(with: geometry) - self.translation,
                self.minBottomSheetHeight
            ),
            self.maxBottomSheetHeight(with: geometry)
        )
    }
    
    // For iPhone landscape, iPad and Mac support
    func width(with geometry: GeometryProxy) -> CGFloat {
        switch self.configuration.sheetWidth {
            
        case .platformDefault:
            return self.platformDefaultWidth(with: geometry)
            
        case .relative(let width):
            // Don't allow the width to be smaller than zero, or larger than one
            return geometry.size.width * max(
                0,
                min(
                    1,
                    width
                )
            )
            
        case .absolute(let width):
            return max(
                0,
                width
            )
        }
    }
    
    func platformDefaultWidth(with geometry: GeometryProxy) -> CGFloat {
#if os(macOS)
        // On Mac use 30% of the width
        return geometry.size.width * 0.3
#else
        if self.isIPad {
            // On iPad use 30% of the width
            return geometry.size.width * 0.3
        } else if UIDevice.current.userInterfaceIdiom == .phone && UIDevice.current.orientation.isLandscape {
            // On iPhone landscape use 40% of the width
            return geometry.size.width * 0.4
        } else {
            // On iPhone portrait or iPad split screen use 100% of the width minus side padding
            return geometry.size.width - self.configuration.sheetSidePadding.leading - self.configuration.sheetSidePadding.trailing
        }
#endif
    }
    
    // For `backgroundBlur`
    func opacity(with geometry: GeometryProxy) -> Double {
        if self.configuration.isBackgroundBlurEnabled {
            // Calculate background blur relative to BottomSheet height
            return min(
                max(
                    Double(
                        self.height(with: geometry) / self.maxBottomSheetHeight(with: geometry)
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
    
    // For `endEditing`
    func endEditing() {
#if !os(macOS)
        UIApplication.shared.endEditing()
#endif
    }
    
    // For position switching
    func getSwitchablePositions(with geometry: GeometryProxy) -> [(
        height: CGFloat,
        position: BottomSheetPosition
    )] {
        return self.switchablePositions.compactMap({ (position) -> (
            height: CGFloat,
            position: BottomSheetPosition
        )? in
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

    func getGestureTranslation(for value: DragGesture.Value) -> CGFloat {
        // For iPad floating and Mac:
        //   - For top alignments: Reverse translation direction
        //   - For other alignments: Use normal translation direction
        // For other devices: Use normal translation direction
        if self.isIPadFloatingOrMac {
            return self.isIPadSheetAlignmentTop ? -value.translation.height : value.translation.height
        } else {
            return value.translation.height
        }
    }
}
