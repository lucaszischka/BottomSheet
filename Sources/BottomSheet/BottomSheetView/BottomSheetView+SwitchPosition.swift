//
//  BottomSheetView+SwitchPosition.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

internal extension BottomSheetView {
    
    // For `flickThrough`
    
    func switchPosition(
        with geometry: GeometryProxy,
        translation: CGFloat
    ) {
        // The height in percent relative to the screen height the user has dragged
        let height: CGFloat = translation / geometry.size.height
        
        // An array with all switchablePositions sorted by height (low to high), excluding .dynamic... and .hidden
        let switchablePositions = self.getSwitchablePositions(
            with: geometry
        )
        
        // The height of the currentBottomSheetPosition; nil if .dynamic...
        let currentHeight = self.bottomSheetPosition.asScreenHeight(with: geometry)
        
        
        if self.configuration.isFlickThroughEnabled {
            self.switchPositonWithFlickThrough(
                with: height,
                switchablePositions: switchablePositions,
                currentHeight: currentHeight ?? self.contentHeight
            )
        } else {
            self.switchPositonWithoutFlickThrough(
                with: height,
                switchablePositions: switchablePositions,
                currentHeight: currentHeight ?? self.contentHeight
            )
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
            switch self.bottomSheetPosition {
            case .dynamicBottom:
                if self.switchablePositions.contains(.dynamicTop) {
                    // 1. dynamicTop
                    self.bottomSheetPosition = .dynamicTop
                } else if self.switchablePositions.contains(.dynamic) {
                    // 2. dynamic
                    self.bottomSheetPosition = .dynamic
                } else if let highestPosition = switchablePositions.last?.position {
                    // 3. highest position
                    self.bottomSheetPosition = highestPosition
                }
            case .dynamic:
                if self.switchablePositions.contains(.dynamicTop) {
                    // 1. dynamicTop
                    self.bottomSheetPosition = .dynamicTop
                } else {
                    fallthrough
                }
            default:
                if let highestPosition = switchablePositions.last?.position {
                    // 1. highest position
                    self.bottomSheetPosition = highestPosition
                }
            }
        } else if height >= 0.1 && height < 0.3 {
            // Go down one position
            self.onePositionSwitchDown(
                switchablePositions: switchablePositions,
                currentHeight: currentHeight
            )
        } else if height >= 0.3 && self.configuration.isSwipeToDismissEnabled {
            self.bottomSheetPosition = .hidden
        } else if height >= 0.3 {
            // Go down to lowest position
            switch self.bottomSheetPosition {
            case .dynamicTop:
                if self.switchablePositions.contains(.dynamic) {
                    // 1. dynamic
                    self.bottomSheetPosition = .dynamic
                } else {
                    fallthrough
                }
            case .dynamic:
                if self.switchablePositions.contains(.dynamicBottom) {
                    // 1. dynamicBottom
                    self.bottomSheetPosition = .dynamicBottom
                } else {
                    fallthrough
                }
            default:
                if let lowestPosition = switchablePositions.first?.position, lowestPosition != self.bottomSheetPosition {
                    // 1. lowest position that is not the current one
                    self.bottomSheetPosition = lowestPosition
                }
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
            self.bottomSheetPosition = .hidden
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
            if self.switchablePositions.contains(.dynamicTop) {
                // 1. dynamicTop
                self.bottomSheetPosition = .dynamicTop
            } else {
                fallthrough
            }
        default:
            if let position = switchablePositions.first(where: { $0.height > currentHeight })?.position {
                // 1. lowest value that is higher than current height
                self.bottomSheetPosition = position
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
        case .dynamicTop:
            if self.switchablePositions.contains(.dynamic) {
                // 1. dynamic
                self.bottomSheetPosition = .dynamic
            } else {
                fallthrough
            }
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
            }
        }
    }
}
