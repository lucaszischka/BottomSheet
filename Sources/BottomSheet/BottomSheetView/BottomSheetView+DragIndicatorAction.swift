//
//  BottomSheetView+DragIndicatorAction.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

internal extension BottomSheetView {
    
    // For `dragIndicator`
    
    func dragIndicatorAction(
        with geometry: GeometryProxy
    ) {
        // An array with all switchablePositions sorted by height (low to high), excluding .dynamic... and .hidden
        let switchablePositions = self.getSwitchablePositions(
            with: geometry
        )
        
        // The height of the currentBottomSheetPosition; nil if .dynamic...
        let currentHeight = self.bottomSheetPosition.asScreenHeight(with: geometry)
        
        
        switch self.bottomSheetPosition {
        case .hidden:
            return
        case .dynamicBottom:
            self.dynamicBottomSwitch(
                switchablePositions: switchablePositions
            )
        case .dynamic:
            self.dynamicSwitch(
                switchablePositions: switchablePositions
            )
        case .dynamicTop:
            self.dynamicBottomSwitch(
                switchablePositions: switchablePositions
            )
        case .relativeBottom, .absoluteBottom:
            if let currentHeight = currentHeight {
                self.valueBottomSwitch(
                    switchablePositions: switchablePositions,
                    currentHeight: currentHeight
                )
            }
        case .relative, .absolute:
            if let currentHeight = currentHeight {
                self.valueSwitch(
                    switchablePositions: switchablePositions,
                    currentHeight: currentHeight
                )
            }
        case .relativeTop, .absoluteTop:
            if let currentHeight = currentHeight {
                self.valueTopSwitch(
                    switchablePositions: switchablePositions,
                    currentHeight: currentHeight
                )
            }
        }
        
        self.endEditing()
    }
    
    private func dynamicBottomSwitch(
        switchablePositions: [(
            height: CGFloat,
            position: BottomSheetPosition
        )]
    ) {
        if self.switchablePositions.contains(.dynamic) {
            // 1. dynamic
            self.bottomSheetPosition = .dynamic
        } else if self.switchablePositions.contains(.dynamicTop) {
            // 2. dynamicTop
            self.bottomSheetPosition = .dynamicTop
        } else if let position = switchablePositions.first(where: { !$0.position.isTop && !$0.position.isBottom })?.position {
            // 3. lowest value that is "middle"
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.first(where: { $0.position.isTop })?.position {
            // 4. lowest value that is top
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.last(where: { $0.position.isBottom })?.position {
            // 5. highest value that is bottom
            self.bottomSheetPosition = position
        }
    }
    
    private func dynamicSwitch(
        switchablePositions: [(
            height: CGFloat,
            position: BottomSheetPosition
        )]
    ) {
        if self.switchablePositions.contains(.dynamicTop) {
            // 1. dynamicTop
            self.bottomSheetPosition = .dynamicTop
        } else if self.switchablePositions.contains(.dynamicBottom) {
            // 2. dynamicBottom
            self.bottomSheetPosition = .dynamicBottom
        } else if let position = switchablePositions.first(where: { $0.position.isTop })?.position {
            // 3. lowest value that is top
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.last(where: { !$0.position.isTop && !$0.position.isBottom })?.position {
            // 4. highest value that is "middle"
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.last(where: { $0.position.isBottom })?.position {
            // 5. highest value that is bottom
            self.bottomSheetPosition = position
        }
    }
    
    private func dynamicTopSwitch(
        switchablePositions: [(
            height: CGFloat,
            position: BottomSheetPosition
        )]
    ) {
        if self.switchablePositions.contains(.dynamic) {
            // 1. dynamic
            self.bottomSheetPosition = .dynamic
        } else if self.switchablePositions.contains(.dynamicBottom) {
            // 2. dynamicBottom
            self.bottomSheetPosition = .dynamicBottom
        } else if let position = switchablePositions.last(where: { !$0.position.isTop && !$0.position.isBottom })?.position {
            // 3. highest value that is "middle"
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.last(where: { $0.position.isBottom })?.position {
            // 4. highest value that is bottom
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.first(where: { $0.position.isTop })?.position {
            // 5. lowest value that is top
            self.bottomSheetPosition = position
        }
    }
    
    private func valueBottomSwitch(
        switchablePositions: [(
            height: CGFloat,
            position: BottomSheetPosition
        )],
        currentHeight: CGFloat
    ) {
        if let position = switchablePositions.first(where: { !$0.position.isTop && !$0.position.isBottom && $0.height > currentHeight })?.position {
            // 1.1 lowest value that is "middle" and higher than current height
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.first(where: { $0.position.isTop && $0.height > currentHeight })?.position {
            // 2.1 lowest value that is top and higher than current height
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.last(where: { $0.position.isBottom && $0.height > currentHeight })?.position {
            // 3.1 highest value that is bottom and higher than current height
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.first(where: { !$0.position.isTop && !$0.position.isBottom })?.position {
            // 1.2 lowest value that is "middle"
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.first(where: { $0.position.isTop })?.position {
            // 2.2 lowest value that is top
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.last(where: { $0.position.isBottom })?.position {
            // 3.2 highest value that is bottom
            self.bottomSheetPosition = position
        } else if self.switchablePositions.contains(.dynamic) {
            // 4. dynamic
            self.bottomSheetPosition = .dynamic
        } else if self.switchablePositions.contains(.dynamicTop) {
            // 5. dynamicTop
            self.bottomSheetPosition = .dynamicTop
        } else if self.switchablePositions.contains(.dynamicBottom) {
            // 6. dynamicBottom
            self.bottomSheetPosition = .dynamicBottom
        }
    }
    
    private func valueSwitch(
        switchablePositions: [(
            height: CGFloat,
            position: BottomSheetPosition
        )],
        currentHeight: CGFloat
    ) {
        if let position = switchablePositions.first(where: { $0.position.isTop && $0.height > currentHeight })?.position {
            // 1.1 lowest value that is top and higher than current height
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.last(where: { !$0.position.isTop && !$0.position.isBottom && $0.height > currentHeight })?.position {
            // 2.1 highest value that is "middle" and higher than current height
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.last(where: { $0.position.isBottom && $0.height > currentHeight })?.position {
            // 3.1 highest value that is bottom and higher than current height
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.first(where: { $0.position.isTop })?.position {
            // 1.2 lowest value that is top
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.last(where: { !$0.position.isTop && !$0.position.isBottom })?.position {
            // 2.2 highest value that is "middle"
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.last(where: { $0.position.isBottom })?.position {
            // 3.2 highest value that is bottom
            self.bottomSheetPosition = position
        } else if self.switchablePositions.contains(.dynamicTop) {
            // 4. dynamicTop
            self.bottomSheetPosition = .dynamicTop
        } else if self.switchablePositions.contains(.dynamicBottom) {
            // 5. dynamicBottom
            self.bottomSheetPosition = .dynamicBottom
        } else if self.switchablePositions.contains(.dynamic) {
            // 6. dynamic
            self.bottomSheetPosition = .dynamic
        }
    }
    
    private func valueTopSwitch(
        switchablePositions: [(
            height: CGFloat,
            position: BottomSheetPosition
        )],
        currentHeight: CGFloat
    ) {
        if let position = switchablePositions.last(where: { !$0.position.isTop && !$0.position.isBottom && $0.height < currentHeight })?.position {
            // 1.1 highest value that is "middle" and lower than current height
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.last(where: { $0.position.isBottom && $0.height < currentHeight })?.position {
            // 2.1 highest value that is bottom and lower than current height
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.first(where: { $0.position.isTop  && $0.height < currentHeight })?.position {
            // 3.1 highest value that is top and lower than current height
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.last(where: { !$0.position.isTop && !$0.position.isBottom })?.position {
            // 1.2 highest value that is "middle"
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.last(where: { $0.position.isBottom })?.position {
            // 2.2 highest value that is bottom
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.first(where: { $0.position.isTop })?.position {
            // 3.2 lowest value that is top
            self.bottomSheetPosition = position
        } else if self.switchablePositions.contains(.dynamic) {
            // 4. dynamic
            self.bottomSheetPosition = .dynamic
        } else if self.switchablePositions.contains(.dynamicBottom) {
            // 5. dynamicBottom
            self.bottomSheetPosition = .dynamicBottom
        } else if self.switchablePositions.contains(.dynamicTop) {
            // 6. dynamicTop
            self.bottomSheetPosition = .dynamicTop
        }
    }
}
