//
//  BottomSheet.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//

import SwiftUI

public struct BottomSheet {
    ///The options to adjust the behavior and the settings of the BottomSheet.
    public enum Options: Equatable {
        public static func == (lhs: BottomSheet.Options, rhs: BottomSheet.Options) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }
        
        ///Blurs the background when pulling up the BottomSheet.
        case backgroundBlur
        ///Changes the color of the drag indicator.
        case dragIndicatorColor(Color)
        ///Prevents the lowest value (above 0) from being the bottom position and hiding the main content.
        case noBottomPosition
        ///Hides the drag indicator.
        case noDragIndicator
        ///Hides the drag indicator and prevents the BottomSheet from being dragged.
        case notResizeable
        ///Shows a close button and declares an action to be performed when tapped.
        case showCloseButton(action: () -> Void = {})
        ///Dismisses the BottomSheet when swiped down.
        case swipeToDismiss
        ///Dismisses the BottomSheet when the background is tapped.
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
