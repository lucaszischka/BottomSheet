//
//  BottomSheet.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//

import Foundation

public struct BottomSheet {
    public enum Options: Equatable {
        public static func == (lhs: BottomSheet.Options, rhs: BottomSheet.Options) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }
        
        case showCloseButton(action: () -> Void = {})
        //case dragToDismiss
        //case appleScrollBehavior
        case noDragIndicator
        case noBottomPosition
        case notResizeable
        
        var rawValue: String {
            switch self {
            case .showCloseButton:
                return "showCloseButton"
            //case .dragToDismiss:
                //return "dragToDismiss"
            //case .appleScrollBehavior:
                //return "appleScrollBehavior"
            case .noDragIndicator:
                return "noDragIndicator"
            case .noBottomPosition:
                return "noBottomPosition"
            case .notResizeable:
                return "notResizeable"
            }
        }
    }
}
