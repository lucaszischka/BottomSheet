//
//  BottomSheet.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//

import SwiftUI

public struct BottomSheet {
    ///The options for changing the behavior and settings of the BottomSheet
    public enum Options: Equatable {
        public static func == (lhs: BottomSheet.Options, rhs: BottomSheet.Options) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }
        
        ///An option to blur the background when moving the BottomSheet up
        case backgroundBlur
        ///An option to change the color of the drag indicator
        case dragIndicatorColor(Color)
        ///An option that prevents the lowest value (greater than 0) from being the bottom position and hiding the main content
        case noBottomPosition
        ///An option to hide the drag indicator
        case noDragIndicator
        ///An option to hide the drag indicator and prevent the BottomSheet from being dragged
        case notResizeable
        ///An option to show the close button and define an action when tapped
        case showCloseButton(action: () -> Void = {})
        ///An option to close the BottomSheet when swiping it down
        case swipeToDismiss
        ///An option to close the BottomSheet when tapping on the background
        case tapToDissmiss
        
        /**
         The corresponding value of the raw type.
         
         A new instance initialized with rawValue will be equivalent to this instance. For example:
         ```
         enum PaperSize: String {
             case A4, A5, Letter, Legal
         }

         let selectedSize = PaperSize.Letter
         print(selectedSize.rawValue)
         // Prints "Letter"

         print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
         // Prints "true"
         ```
         */
        public var rawValue: String {
            switch self {
            case .backgroundBlur:
                return "backgroundBlur"
            case .dragIndicatorColor:
                return "dragIndicatorColor"
            case .noBottomPosition:
                return "noBottomPosition"
            case .noDragIndicator:
                return "noDragIndicator"
            case .notResizeable:
                return "notResizeable"
            case .showCloseButton:
                return "showCloseButton"
            case .swipeToDismiss:
                return "swipeToDismiss"
            case .tapToDissmiss:
                return "tapToDissmiss"
            }
        }
    }
}

internal extension Array where Element == BottomSheet.Options {
    var backgroundBlur: Bool {
        self.contains(BottomSheet.Options.backgroundBlur)
    }
    
    var dragIndicatorColor: Bool {
        self.contains(BottomSheet.Options.dragIndicatorColor(Color.clear))
    }
    
    var noBottomPosition: Bool {
        self.contains(BottomSheet.Options.noBottomPosition)
    }
    
    var noDragIndicator: Bool {
        self.contains(BottomSheet.Options.noDragIndicator)
    }
    
    var notResizeable: Bool {
        self.contains(BottomSheet.Options.notResizeable)
    }
    
    
    var showCloseButton: Bool {
        self.contains(BottomSheet.Options.showCloseButton())
    }
    
    var closeAction: () -> Void {
        var closeAction: () -> Void = {}
        
        self.forEach { item in
            switch item {
            case .showCloseButton(action: let action):
                closeAction = action
            default:
                return
            }
        }
        
        return closeAction
    }
    
    var swipeToDismiss: Bool {
        self.contains(BottomSheet.Options.swipeToDismiss)
    }
    
    var tapToDismiss: Bool {
        self.contains(BottomSheet.Options.tapToDissmiss)
    }
}
