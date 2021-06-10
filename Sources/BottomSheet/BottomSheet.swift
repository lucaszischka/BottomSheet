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
        
        ///Allows the BottomSheet to move when dragging the mainContent. Do not use if the mainContent is packed into a ScrollView.
        case allowContentDrag
        ///Sets the animation for opening and closing the BottomSheet.
        case animation(Animation)
        ///The mainView is packed into a ScrollView, which can only scrolled at the .top position
        case appleScrollBehavior
        ///Changes the background of the BottomSheet. Must be erased to AnyView
        case background(AnyView)
        ///Blurs the background when pulling up the BottomSheet.
        case backgroundBlur
        ///Changes the color of the drag indicator.
        case dragIndicatorColor(Color)
        ///Prevents the lowest value (above 0) from being the bottom position and hiding the mainContent.
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
            case .allowContentDrag:
                return "allowContentDrag"
            case .animation:
                return "animation"
            case .appleScrollBehavior:
                return "appleScrollBehavior"
            case .background:
                return "background"
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
    var allowContentDrag: Bool {
        self.contains(BottomSheet.Options.allowContentDrag)
    }
    
    var animation: Animation {
        var animation = Animation.spring(response: 0.5, dampingFraction: 0.75, blendDuration: 1)
        
        self.forEach { item in
            if case .animation(let customAnimation) = item {
                animation = customAnimation
            }
        }
        
        return animation
    }
    
    var appleScrollBehavior: Bool {
        self.contains(BottomSheet.Options.appleScrollBehavior)
    }
    
    var background: AnyView {
        var background = AnyView(EffectView(effect: UIBlurEffect(style: .systemMaterial)))
        
        self.forEach { item in
            if case .background(let customBackground) = item {
                background = customBackground
            }
        }
        
        return background
    }
    
    var backgroundBlur: Bool {
        self.contains(BottomSheet.Options.backgroundBlur)
    }
    
    var dragIndicatorColor: Color {
        var dragIndicatorColor = Color(UIColor.tertiaryLabel)
        
        self.forEach { item in
            if case .dragIndicatorColor(let customDragIndicatorColor) = item {
                dragIndicatorColor = customDragIndicatorColor
            }
        }
        
        return dragIndicatorColor
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
            if case .showCloseButton(action: let customCloseAction) = item {
                closeAction = customCloseAction
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
