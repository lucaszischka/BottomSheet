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
        if self.configuration.isBackgroundBlurEnabled, let height = self.bottomSheetPosition.asScreenHeight(
            with: geometry
        ) {
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
    
    // For `dragIndicator`
    func dragIndicatorAction(
        with geometry: GeometryProxy
    ) {
        // Doesn't contain .dynamic and .dynamicTop -> you cant switch into it via indicator
        let switchablePositions = self.getSwitchablePositions(
            with: geometry
        )
        
        if !self.bottomSheetPosition.isHidden && switchablePositions.count > 1 {
            if let currentIndex = switchablePositions.firstIndex(where: {
                $0.position == self.bottomSheetPosition
            }) {
                if currentIndex == switchablePositions.endIndex - 1 {
                    if switchablePositions[currentIndex - 1].height != 0 {
                        self.bottomSheetPosition = switchablePositions[currentIndex - 1].position
                    }
                } else {
                    self.bottomSheetPosition = switchablePositions[currentIndex + 1].position
                }
                
                self.endEditing()
            } else {
                // The current position is not contained in switchablePositions
            }
        }
    }
    
    // General usage
    func closeSheet() {
        self.bottomSheetPosition = .hidden
        self.endEditing()
        
        self.configuration.onDismiss()
    }
    
    // For `headerContent
    func headerContentPadding(
        with geometry: GeometryProxy
    ) -> CGFloat {
        if self.bottomSheetPosition.isBottom {
            return geometry.safeAreaInsets.bottom + 25
        } else if self.headerContent == nil && !self.configuration.isCloseButtonShown {
            return 20
        } else {
            return 0
        }
    }
    
    // For `flickThrough`
    func switchPosition(
        with geometry: GeometryProxy,
        translation: CGFloat
    ) {
        // Doesn't contain .dynamic and .dynamicTop -> you cant switch into it via drag
        let switchablePositions = self.getSwitchablePositions(
            with: geometry
        )
        
        if !self.bottomSheetPosition.isHidden, switchablePositions.count > 1 {
            if let currentIndex = switchablePositions.firstIndex(where: {
                $0.position == self.bottomSheetPosition
            }) {
                let height: CGFloat = translation / geometry.size.height
                
                if self.configuration.isFlickThroughEnabled {
                    self.switchPositonWithFlickThrough(
                        with: height,
                        currentIndex: currentIndex,
                        switchablePositions: switchablePositions
                    )
                } else {
                    self.switchPositonWithoutFlickThrough(
                        with: height,
                        currentIndex: currentIndex,
                        switchablePositions: switchablePositions
                    )
                }
            } else {
                // The current position is not contained in switchablePositions
            }
        }
    }
    
    // For `flickThrough`
    func switchPositonWithoutFlickThrough(
        with height: CGFloat,
        currentIndex: Int,
        switchablePositions: [(
            height: CGFloat,
            position: BottomSheetPosition
        )]
    ) {
        if height <= -0.1 {
            if currentIndex < switchablePositions.endIndex - 1 {
                self.bottomSheetPosition = switchablePositions[currentIndex + 1].position
            }
        } else if height >= 0.1 {
            if currentIndex > switchablePositions.startIndex && (
                switchablePositions[currentIndex - 1].height != 0 || (
                    switchablePositions[currentIndex - 1].height == 0 && self.configuration.isSwipeToDismissEnabled
                )
            ) {
                self.bottomSheetPosition = switchablePositions[currentIndex - 1].position
            }
        }
    }
    
    // For `flickThrough`
    func switchPositonWithFlickThrough(
        with height: CGFloat,
        currentIndex: Int,
        switchablePositions: [(
            height: CGFloat,
            position: BottomSheetPosition
        )]
    ) {
        if height <= -0.1 && height > -0.3 {
            if currentIndex < switchablePositions.endIndex - 1 {
                self.bottomSheetPosition = switchablePositions[currentIndex + 1].position
            }
        } else if height <= -0.3 {
            self.bottomSheetPosition = switchablePositions[switchablePositions.endIndex - 1].position
        } else if height >= 0.1 && height < 0.3 {
            if currentIndex > switchablePositions.startIndex &&
                (switchablePositions[currentIndex - 1].height != 0 ||
                 (switchablePositions[currentIndex - 1].height == 0 &&
                  self.configuration.isSwipeToDismissEnabled)
                ) {
                self.bottomSheetPosition = switchablePositions[currentIndex - 1].position
            }
        } else if height >= 0.3 {
            if (switchablePositions[switchablePositions.startIndex].height == 0 &&
                self.configuration.isSwipeToDismissEnabled) ||
                switchablePositions[switchablePositions.startIndex].height != 0 {
                self.bottomSheetPosition = switchablePositions[switchablePositions.startIndex].position
            } else {
                self.bottomSheetPosition = switchablePositions[switchablePositions.startIndex + 1].position
            }
        }
    }
    
    // For `landscape`, `iPad`, `Mac` and `Tv` support
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
            return nil
        }
    }
    
    // For `bottomSheetPosition`
    func offsetY(
        with geometry: GeometryProxy
    ) -> Double {
        if self.isIPadOrMac {
            return 0
        } else {
        if let height = self.bottomSheetPosition.asScreenHeight(
            with: geometry
        ) {
            if self.bottomSheetPosition.isHidden {
                return max(
                    geometry.size.height + geometry.safeAreaInsets.bottom,
                    geometry.size.height * -0.05
                )
            } else if self.bottomSheetPosition.isBottom {
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
        } else {
            return max(
                geometry.size.height - self.contentHeight +
                self.translation,
                geometry.size.height * -0.05
            )
        }
        }
    }
    
    // General usage
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
                return (
                    height: height,
                    position: position
                )
            } else if self.bottomSheetPosition == position {
                return (
                    height: self.contentHeight,
                    position: position
                )
            } else {
                return nil
            }
        }).sorted(by: {
            $0.height < $1.height
        })
    }
}
