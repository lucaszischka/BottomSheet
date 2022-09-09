//
//  BottomSheetView+Gestures.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

internal extension BottomSheetView {
    func dragGesture(with geometry: GeometryProxy) -> some Gesture {
        DragGesture()
            .onChanged { value in
                // Perform custom onChanged action
                self.configuration.onDragChanged(value)
                
                // Update translation; on iPad floating and Mac the drag direction is reversed
                self.translation = self.isIPadFloatingOrMac ? -value.translation.height : value.translation.height
                // Dismiss the keyboard on drag
                self.endEditing()
            }
            .onEnded { value in
                // Perform custom onEnded action
                self.configuration.onDragEnded(value)
                
                // Switch the position based on the translation and screen height
                self.dragPositionSwitch(
                    with: geometry,
                    value: value
                )
                
                // Reset translation, because the dragging ended
                self.translation = 0
                // Dismiss the keyboard after drag
                self.endEditing()
            }
    }
    
#if !os(macOS)
    func appleScrollViewDragGesture(with geometry: GeometryProxy) -> some Gesture {
        DragGesture()
            .onChanged { value in
                if self.bottomSheetPosition.isTop && value.translation.height < 0 {
                    // Notify the ScrollView that the user is scrolling
                    self.dragState = .changed(value: value)
                    // Reset translation, because the user is scrolling
                    self.translation = 0
                } else {
                    // Perform custom action from the user
                    self.configuration.onDragChanged(value)
                    
                    // Notify the ScrollView that the user is dragging
                    self.dragState = .none
                    // Update translation; on iPad floating and Mac the drag direction is reversed
                    self.translation = self.isIPadFloatingOrMac ? -value.translation.height : value.translation.height
                }
                
                // Dismiss the keyboard on dragging/scrolling
                self.endEditing()
            }
            .onEnded { value in
                if value.translation.height < 0 && self.bottomSheetPosition.isTop {
                    // Notify the ScrollView that the user ended scrolling via dragging
                    self.dragState = .ended(value: value)
                    
                    // Reset translation, because the user ended scrolling via dragging
                    self.translation = 0
                    // Enable further interaction via the ScrollView directly
                    self.isScrollEnabled = true
                } else {
                    // Perform custom action from the user
                    self.configuration.onDragEnded(value)
                    
                    // Notify the ScrollView that the user is dragging
                    self.dragState = .none
                    // Switch the position based on the translation and screen height
                    self.dragPositionSwitch(
                        with: geometry,
                        value: value
                    )
                    
                    // Reset translation, because the dragging ended
                    self.translation = 0
                }
                
                // Dismiss the keyboard after dragging/scrolling
                self.endEditing()
            }
    }
#endif
}
