//
//  BottomSheet.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021-2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

public struct BottomSheet {
    ///The options to adjust the behavior and the settings of the BottomSheet.
    public enum Options: Equatable {
        public static func == (lhs: BottomSheet.Options, rhs: BottomSheet.Options) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }
        
        /// Allows absolute values in pixels to be used as BottomSheetPosition values.
        case absolutePositionValue
        /// Allows the BottomSheet to move when dragging the mainContent. Do not use if the mainContent is packed into a ScrollView.
        case allowContentDrag
        /// Sets the animation for opening and closing the BottomSheet.
        case animation(Animation)
        /// The mainView is packed into a ScrollView, which can only scrolled at the .top position.
        case appleScrollBehavior
        /// Changes the background of the BottomSheet. Must be erased to AnyView.
        case background(() -> AnyView)
        /// Enables and sets the blur effect of the background when pulling up the BottomSheet.
        case backgroundBlur(effect: UIBlurEffect.Style = .systemThinMaterial)
        /// Changes the corner radius of the BottomSheet.
        case cornerRadius(Double)
        /// Disables the bottom safe area insets.
        case disableBottomSafeAreaInsets
        /// Disables the flick through feature.
        case disableFlickThrough
        /// Changes the color of the drag indicator.
        case dragIndicatorColor(Color)
        /// Prevents the lowest value (above 0) from being the bottom position and hiding the mainContent.
        case noBottomPosition
        /// Hides the drag indicator.
        case noDragIndicator
        /// Hides the drag indicator and prevents the BottomSheet from being dragged.
        case notResizeable
        /// Adds a shadow to the background of the BottomSheet.
        case shadow(color: Color = Color(.sRGBLinear, white: 0, opacity: 0.33), radius: CGFloat = 10, x: CGFloat = 0, y: CGFloat = 0)
        /// Shows a close button and declares an action to be performed when tapped.
        case showCloseButton(action: () -> Void = {})
        /// Dismisses the BottomSheet when swiped down.
        case swipeToDismiss
        /// Dismisses the BottomSheet when the background is tapped.
        case tapToDismiss
        
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
        var rawValue: String {
            switch self {
            case .absolutePositionValue:
                return "absolutePositionValue"
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
            case .disableBottomSafeAreaInsets:
                return "disableBottomSafeAreaInsets"
            case .disableFlickThrough:
                return "disableFlickThrough"
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
            case .tapToDismiss:
                return "tapToDismiss"
            }
        }
    }
}
