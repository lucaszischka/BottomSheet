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
        ///The mainView is packed into a ScrollView, which can only scrolled at the .top position.
        case appleScrollBehavior
        ///Changes the background of the BottomSheet. Must be erased to AnyView.
        case background(AnyView)
        ///Enables and sets the blur effect of the background when pulling up the BottomSheet.
        case backgroundBlur(effect: UIBlurEffect.Style = .systemThinMaterial)
        ///Changes the corener radius of the BottomSheet.
        case cornerRadius(Double)
        ///Changes the color of the drag indicator.
        case dragIndicatorColor(Color)
        ///Prevents the lowest value (above 0) from being the bottom position and hiding the mainContent.
        case noBottomPosition
        ///Hides the drag indicator.
        case noDragIndicator
        ///Hides the drag indicator and prevents the BottomSheet from being dragged.
        case notResizeable
        ///Adds a shadow to the background of the BottomSheet.
        case shadow(color: Color = Color(.sRGBLinear, white: 0, opacity: 0.33), radius: CGFloat = 10, x: CGFloat = 0, y: CGFloat = 0)
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
            case .cornerRadius:
                return "cornerRadius"
            case .dragIndicatorColor:
                return "dragIndicatorColor"
            case .noBottomPosition:
                return "noBottomPosition"
            case .noDragIndicator:
                return "noDragIndicator"
            case .notResizeable:
                return "notResizeable"
            case .shadow:
                return "shadow"
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
        return self.contains(BottomSheet.Options.allowContentDrag)
    }
    
    var animation: Animation {
        var animation: Animation = Animation.spring(response: 0.5, dampingFraction: 0.75, blendDuration: 1)
        
        self.forEach { item in
            if case .animation(let customAnimation) = item {
                animation = customAnimation
            }
        }
        
        return animation
    }
    
    var appleScrollBehavior: Bool {
        return self.contains(BottomSheet.Options.appleScrollBehavior)
    }
    
    var background: AnyView {
        var background: AnyView = AnyView(EffectView(effect: UIBlurEffect(style: .systemMaterial)))
        
        self.forEach { item in
            if case .background(let customBackground) = item {
                background = customBackground
            }
        }
        
        return background
    }
    
    var backgroundBlur: Bool {
        return self.contains(BottomSheet.Options.backgroundBlur())
    }
    
    var backgroundBlurEffect: UIBlurEffect {
        var blurEffect: UIBlurEffect = UIBlurEffect(style: .systemThinMaterial)
        
        self.forEach { item in
            if case .backgroundBlur(let customBlurEffect) = item {
                blurEffect = UIBlurEffect(style: customBlurEffect)
            }
        }
        
        return blurEffect
    }
    
    var cornerRadius: CGFloat {
        var cornerRadius: CGFloat = 10.0
        
        self.forEach { item in
            if case .cornerRadius(let customCornerRadius) = item {
                cornerRadius = CGFloat(customCornerRadius)
            }
        }
        
        return cornerRadius
    }
    
    var dragIndicatorColor: Color {
        var dragIndicatorColor: Color = Color(UIColor.tertiaryLabel)
        
        self.forEach { item in
            if case .dragIndicatorColor(let customDragIndicatorColor) = item {
                dragIndicatorColor = customDragIndicatorColor
            }
        }
        
        return dragIndicatorColor
    }
    
    var noBottomPosition: Bool {
        return self.contains(BottomSheet.Options.noBottomPosition)
    }
    
    var noDragIndicator: Bool {
        return self.contains(BottomSheet.Options.noDragIndicator)
    }
    
    var notResizeable: Bool {
        return self.contains(BottomSheet.Options.notResizeable)
    }
    
    var shadowColor: Color {
        var shadowColor: Color = .clear
        
        self.forEach { item in
            if case .shadow(color: let customShadowColor, radius: _, x: _, y: _) = item {
                shadowColor = customShadowColor
            }
        }
        
        return shadowColor
    }
    
    var shadowRadius: CGFloat {
        var shadowRadius: CGFloat = 0
        
        self.forEach { item in
            if case .shadow(color: _, radius: let customShadowRadius, x: _, y: _) = item {
                shadowRadius = customShadowRadius
            }
        }
        
        return shadowRadius
    }
    
    var shadowX: CGFloat {
        var shadowX: CGFloat = 0
        
        self.forEach { item in
            if case .shadow(color: _, radius: _, x: let customShadowX, y: _) = item {
                shadowX = customShadowX
            }
        }
        
        return shadowX
    }
    
    var shadowY: CGFloat {
        var shadowY: CGFloat = 0
        
        self.forEach { item in
            if case .shadow(color: _, radius: _, x: _, y: let customShadowY) = item {
                shadowY = customShadowY
            }
        }
        
        return shadowY
    }
    
    var showCloseButton: Bool {
        return self.contains(BottomSheet.Options.showCloseButton())
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
        return self.contains(BottomSheet.Options.swipeToDismiss)
    }
    
    var tapToDismiss: Bool {
        return self.contains(BottomSheet.Options.tapToDissmiss)
    }
}
