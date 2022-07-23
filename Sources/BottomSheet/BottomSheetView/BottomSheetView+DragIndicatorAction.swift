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
        if let dragIndicatorAction = self.configuration.dragIndicatorAction {
            dragIndicatorAction(geometry)
        } else {
            // An array with all switchablePositions sorted by height (low to high),
            // excluding .dynamic..., .hidden and the current position
            let switchablePositions = self.getSwitchablePositions(
                with: geometry
            )
            
            // The height of the currentBottomSheetPosition; if nil use content height
            let currentHeight = self.bottomSheetPosition.asScreenHeight(with: geometry) ?? self.contentHeight
            
            if let currentHeight = currentHeight {
                switch self.bottomSheetPosition {
                case .hidden:
                    return
                case .dynamicBottom:
                    self.dynamicBottomSwitch(
                        switchablePositions: switchablePositions,
                        currentHeight: currentHeight
                    )
                case .dynamic:
                    self.dynamicSwitch(
                        switchablePositions: switchablePositions,
                        currentHeight: currentHeight
                    )
                case .relativeBottom, .absoluteBottom:
                    self.valueBottomSwitch(
                        switchablePositions: switchablePositions,
                        currentHeight: currentHeight
                    )
                case .relative, .absolute:
                    self.valueSwitch(
                        switchablePositions: switchablePositions,
                        currentHeight: currentHeight
                    )
                case .relativeTop, .absoluteTop:
                    self.valueTopSwitch(
                        switchablePositions: switchablePositions,
                        currentHeight: currentHeight
                    )
                }
            }
            
            self.endEditing()
        }
    }
    
    private func dynamicBottomSwitch(
        switchablePositions: [(
            height: CGFloat,
            position: BottomSheetPosition
        )],
        currentHeight: CGFloat
    ) {
        if self.switchablePositions.contains(.dynamic) {
            // 1. dynamic
            self.bottomSheetPosition = .dynamic
        } else if let position = switchablePositions.first(where: {
            !$0.position.isTop && !$0.position.isBottom && $0.height > currentHeight
        })?.position {
            // 2. lowest value that is "middle" and higher than current height
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.first(where: {
            $0.position.isTop && $0.height > currentHeight
        })?.position {
            // 3. lowest value that is top and higher than current height
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.first(where: {
            $0.position.isBottom && $0.height > currentHeight
        })?.position {
            // 4. lowest value that is bottom and higher than current height
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.last(where: {
            !$0.position.isTop && !$0.position.isBottom
        })?.position {
            // 5. highest value that is "middle"
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.last(where: {
            $0.position.isTop
        })?.position {
            // 6. highest value that is top
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.last(where: {
            $0.position.isBottom
        })?.position {
            // 7. highest value that is bottom
            self.bottomSheetPosition = position
        }
    }
    
    private func dynamicSwitch(
        switchablePositions: [(
            height: CGFloat,
            position: BottomSheetPosition
        )],
        currentHeight: CGFloat
    ) {
        if let position = switchablePositions.first(where: {
            !$0.position.isTop && !$0.position.isBottom && $0.height > currentHeight
        })?.position {
            // 1. lowest value that is "middle" and higher than current height
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.first(where: {
            $0.position.isTop && $0.height > currentHeight
        })?.position {
            // 2. lowest value that is top and higher than current height
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.first(where: {
            $0.position.isBottom && $0.height > currentHeight
        })?.position {
            // 3. lowest value that is bottom and higher than current height
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.last(where: {
            $0.position.isTop
        })?.position {
            // 4. highest value that is top
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.last(where: {
            !$0.position.isTop && !$0.position.isBottom
        })?.position {
            // 5. highest value that is "middle"
            self.bottomSheetPosition = position
        } else if self.switchablePositions.contains(.dynamicBottom) {
            // 6. dynamicBottom
            self.bottomSheetPosition = .dynamicBottom
        } else if let position = switchablePositions.last(where: {
            $0.position.isBottom
        })?.position {
            // 7. highest value that is bottom
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
        if let position = switchablePositions.first(where: {
            !$0.position.isTop && !$0.position.isBottom && $0.height > currentHeight
        })?.position {
            // 1. lowest value that is "middle" and higher than current height
            self.bottomSheetPosition = position
        } else if self.switchablePositions.contains(.dynamic) {
            // 2. dynamic
            self.bottomSheetPosition = .dynamic
        } else if let position = switchablePositions.first(where: {
            $0.position.isTop && $0.height > currentHeight
        })?.position {
            // 3. lowest value that is top and higher than current height
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.first(where: {
            $0.position.isBottom && $0.height > currentHeight
        })?.position {
            // 4. lowest value that is bottom and higher than current height
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.last(where: {
            !$0.position.isTop && !$0.position.isBottom
        })?.position {
            // 5. highest value that is "middle"
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.last(where: {
            $0.position.isTop
        })?.position {
            // 6. highest value that is top
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.last(where: {$0.position.isBottom
        })?.position {
            // 7. highest value that is bottom
            self.bottomSheetPosition = position
        } else if self.switchablePositions.contains(.dynamicBottom) {
            // 8. dynamicBottom
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
        if let position = switchablePositions.first(where: {
            !$0.position.isTop && !$0.position.isBottom && $0.height > currentHeight
        })?.position {
            // 1. lowest value that is "middle" and higher than current height
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.first(where: {
            $0.position.isTop && $0.height > currentHeight
        })?.position {
            // 2. lowest value that is top and higher than current height
            self.bottomSheetPosition = position
        }else if let position = switchablePositions.first(where: {
            $0.position.isBottom && $0.height > currentHeight
        })?.position {
            // 3. lowest value that is bottom and higher than current height
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.last(where: {
            $0.position.isTop
        })?.position {
            // 4. highest value that is top
            self.bottomSheetPosition = position
        } else if self.switchablePositions.contains(.dynamic) {
            // 5. dynamic
            self.bottomSheetPosition = .dynamic
        } else if let position = switchablePositions.last(where: {
            !$0.position.isTop && !$0.position.isBottom
        })?.position {
            // 6. highest value that is "middle"
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.last(where: {
            $0.position.isBottom
        })?.position {
            // 7. highest value that is bottom
            self.bottomSheetPosition = position
        } else if self.switchablePositions.contains(.dynamicBottom) {
            // 8. dynamicBottom
            self.bottomSheetPosition = .dynamicBottom
        }
    }
    
    private func valueTopSwitch(
        switchablePositions: [(
            height: CGFloat,
            position: BottomSheetPosition
        )],
        currentHeight: CGFloat
    ) {
        if let position = switchablePositions.last(where: {
            !$0.position.isTop && !$0.position.isBottom && $0.height < currentHeight
        })?.position {
            // 1. highest value that is "middle" and lower than current height
            self.bottomSheetPosition = position
        } else if self.switchablePositions.contains(.dynamic) {
            // 2. dynamic
            self.bottomSheetPosition = .dynamic
        } else if let position = switchablePositions.last(where: {
            $0.position.isBottom && $0.height < currentHeight
        })?.position {
            // 3. highest value that is bottom and lower than current height
            self.bottomSheetPosition = position
        } else if self.switchablePositions.contains(.dynamicBottom) {
            // 4. dynamicBottom
            self.bottomSheetPosition = .dynamicBottom
        } else if let position = switchablePositions.first(where: {
            $0.position.isTop  && $0.height < currentHeight
        })?.position {
            // 5. highest value that is top and lower than current height
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.last(where: {
            !$0.position.isTop && !$0.position.isBottom
        })?.position {
            // 6. highest value that is "middle"
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.last(where: {
            $0.position.isBottom
        })?.position {
            // 7. highest value that is bottom
            self.bottomSheetPosition = position
        } else if let position = switchablePositions.first(where: {
            $0.position.isTop
        })?.position {
            // 8. lowest value that is top
            self.bottomSheetPosition = position
        }
    }
}
