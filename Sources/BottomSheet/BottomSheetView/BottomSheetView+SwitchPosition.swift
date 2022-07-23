//
//  BottomSheetView+SwitchPosition.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

internal extension BottomSheetView {
    
    // For `flickThrough`
    
    func dragPositionSwitch(
        with geometry: GeometryProxy,
        value: DragGesture.Value
    ) {
        if let dragPositionSwitchAction = self.configuration.dragPositionSwitchAction {
            dragPositionSwitchAction(geometry, value)
        } else {
            // On iPad and Mac the drag direction is reversed
            let translationHeight: CGFloat = self.isIPadOrMac ? -value.translation.height : value.translation.height
            // The height in percent relative to the screen height the user has dragged
            let height: CGFloat = translationHeight / geometry.size.height
            
            // An array with all switchablePositions sorted by height (low to high),
            // excluding .dynamic..., .hidden and the current position
            let switchablePositions = self.getSwitchablePositions(
                with: geometry
            )
            
            // The height of the currentBottomSheetPosition; if nil use content height
            let currentHeight = self.bottomSheetPosition.asScreenHeight(with: geometry) ?? self.contentHeight
            
            if let currentHeight = currentHeight {
                if self.configuration.isFlickThroughEnabled {
                    self.switchPositonWithFlickThrough(
                        with: height,
                        switchablePositions: switchablePositions,
                        currentHeight: currentHeight
                    )
                } else {
                    self.switchPositonWithoutFlickThrough(
                        with: height,
                        switchablePositions: switchablePositions,
                        currentHeight: currentHeight
                    )
                }
            }
        }
    }
    
    private func switchPositonWithFlickThrough(
        with height: CGFloat,
        switchablePositions: [(
            height: CGFloat,
            position: BottomSheetPosition
        )],
        currentHeight: CGFloat
    ) {
        if height <= -0.1 && height > -0.3 {
            // Go up one position
            self.onePositionSwitchUp(
                switchablePositions: switchablePositions,
                currentHeight: currentHeight
            )
        } else if height <= -0.3 {
            // Go up to highest position
            self.switchToHighestPosition(
                switchablePositions: switchablePositions,
                currentHeight: currentHeight
            )
        } else if height >= 0.1 && height < 0.3 {
            // Go down one position
            self.onePositionSwitchDown(
                switchablePositions: switchablePositions,
                currentHeight: currentHeight
            )
        } else if height >= 0.3 && self.configuration.isSwipeToDismissEnabled {
            self.closeSheet()
        } else if height >= 0.3 {
            // Go down to lowest position
            self.switchToLowestPosition(
                switchablePositions: switchablePositions,
                currentHeight: currentHeight
            )
        }
    }
    
    private func switchToHighestPosition(
        switchablePositions: [(
            height: CGFloat,
            position: BottomSheetPosition
        )],
        currentHeight: CGFloat
    ) {
        switch self.bottomSheetPosition {
        case .dynamicBottom:
            if self.switchablePositions.contains(.dynamic) {
                // 1. dynamic
                self.bottomSheetPosition = .dynamic
            } else if let highest = switchablePositions.last, highest.height > currentHeight {
                // 2. highest position
                self.bottomSheetPosition = highest.position
            }
        case .dynamic:
            if let highest = switchablePositions.last, highest.height > currentHeight {
                // 1. highest position
                self.bottomSheetPosition = highest.position
            }
        default:
            if let highest = switchablePositions.last, highest.height > currentHeight {
                // 1. highest position
                self.bottomSheetPosition = highest.position
            }
        }
    }
    
    private func switchToLowestPosition(
        switchablePositions: [(
            height: CGFloat,
            position: BottomSheetPosition
        )],
        currentHeight: CGFloat
    ) {
        switch self.bottomSheetPosition {
        case .dynamic:
            if self.switchablePositions.contains(.dynamicBottom) {
                // 1. dynamicBottom
                self.bottomSheetPosition = .dynamicBottom
            } else if let lowest = switchablePositions.first, lowest.height < currentHeight {
                // 2. lowest position that is lower than the current one
                self.bottomSheetPosition = lowest.position
            }
        default:
            if let lowest = switchablePositions.first, lowest.height < currentHeight {
                // 1. lowest position that is lower than the current one
                self.bottomSheetPosition = lowest.position
            }
        }
    }
    
    private func switchPositonWithoutFlickThrough(
        with height: CGFloat,
        switchablePositions: [(
            height: CGFloat,
            position: BottomSheetPosition
        )],
        currentHeight: CGFloat
    ) {
        if height <= -0.1 {
            // Go up one position
            self.onePositionSwitchUp(
                switchablePositions: switchablePositions,
                currentHeight: currentHeight
            )
        } else if height >= 0.3 && self.configuration.isSwipeToDismissEnabled {
            self.closeSheet()
        } else if height >= 0.1 {
            // Go down one position
            self.onePositionSwitchDown(
                switchablePositions: switchablePositions,
                currentHeight: currentHeight
            )
        }
    }
    
    private func onePositionSwitchUp(
        switchablePositions: [(
            height: CGFloat,
            position: BottomSheetPosition
        )],
        currentHeight: CGFloat
    ) {
        switch self.bottomSheetPosition {
        case .hidden:
            return
        case .dynamicBottom:
            if self.switchablePositions.contains(.dynamic) {
                // 1. dynamic
                self.bottomSheetPosition = .dynamic
            } else {
                fallthrough
            }
        case .dynamic:
            fallthrough
        default:
            if let position = switchablePositions.first(where: { $0.height > currentHeight })?.position {
                // 1. lowest value that is higher than current height
                self.bottomSheetPosition = position
            } else if self.bottomSheetPosition.isBottom {
                // 2. if currently bottom
                
                if self.switchablePositions.contains(.dynamic) {
                    // 2.1 dynamic
                    self.bottomSheetPosition = .dynamic
                }
            }
        }
    }
    
    private func onePositionSwitchDown(
        switchablePositions: [(
            height: CGFloat,
            position: BottomSheetPosition
        )],
        currentHeight: CGFloat
    ) {
        switch self.bottomSheetPosition {
        case .hidden:
            return
        case .dynamic:
            if self.switchablePositions.contains(.dynamicBottom) {
                // 1. dynamicBottom
                self.bottomSheetPosition = .dynamicBottom
            } else {
                fallthrough
            }
        default:
            if let position = switchablePositions.last(where: { $0.height < currentHeight })?.position {
                // 1. highest value that is lower than current height
                self.bottomSheetPosition = position
            } else if self.bottomSheetPosition.isTop {
                // 2. if currently top
                
                if self.switchablePositions.contains(.dynamic) {
                    // 2.1 dynamic
                    self.bottomSheetPosition = .dynamic
                } else if self.switchablePositions.contains(.dynamicBottom) {
                    // 2.2 dynamicBottom
                    self.bottomSheetPosition = .dynamicBottom
                }
            } else if !self.bottomSheetPosition.isBottom {
                // 3. if currently "medium"
                if self.switchablePositions.contains(.dynamicBottom) {
                    // 3.1 dynamicTop
                    self.bottomSheetPosition = .dynamicBottom
                }
            }
        }
    }
}
