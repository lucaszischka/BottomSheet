//
//  BottomSheetPosition.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//

import SwiftUI


//BottomSheetPosition
public protocol BottomSheetPosition {
    
    associatedtype BottomSheetPositions: RawRepresentable where BottomSheetPositions.RawValue == CGFloat
    
    var bottomSheetPosition: BottomSheetPositions { get set }
    
    func switchPositionIndicator() -> Void
    
    func switchPosition(with height: CGFloat) -> Void
    
    func isBottom() -> Bool
    
    func isHidden() -> Bool
    
    init(bottomSheetPosition: BottomSheetPositions)
}


//4 States: .hidden, .bottom, .middle, .top
class HBMTBottomSheetPosition: BottomSheetPosition {
    
    var bottomSheetPosition: BottomSheetPositions
    
    
    func switchPositionIndicator() -> Void {
        switch self.bottomSheetPosition {
        case .top:
            self.bottomSheetPosition = .middle
        case .middle:
            self.bottomSheetPosition = .top
        case .bottom:
            self.bottomSheetPosition = .middle
        case .hidden:
            self.bottomSheetPosition = .hidden
        }
    }
    
    func switchPosition(with height: CGFloat) -> Void {
        if bottomSheetPosition != .hidden {
            if height <= -0.1 && height > -0.3 {
                if self.bottomSheetPosition == .bottom {
                    self.bottomSheetPosition = .middle
                } else {
                    self.bottomSheetPosition = .top
                }
            } else if height <= -0.3 {
                self.bottomSheetPosition = .top
            } else if height >= 0.1 && height < 0.3 {
                if self.bottomSheetPosition == .top {
                    self.bottomSheetPosition = .middle
                } else {
                    self.bottomSheetPosition = .bottom
                }
            } else if height >= 0.3 {
                self.bottomSheetPosition = .bottom
            }
        }
    }
    
    func isBottom() -> Bool {
        return self.bottomSheetPosition == .bottom
    }
    
    func isHidden() -> Bool {
        return self.bottomSheetPosition == .hidden
    }
    
    
    enum BottomSheetPositions: CGFloat {
        case top = 0.975, middle = 0.4, bottom = 0.125, hidden = 0
    }
    
    
    required init(bottomSheetPosition: BottomSheetPositions) {
        self.bottomSheetPosition = bottomSheetPosition
    }
}

//3 States: .hidden, .bottom, .middle
class HBMBottomSheetPosition: BottomSheetPosition {
    
    var bottomSheetPosition: BottomSheetPositions
    
    
    func switchPositionIndicator() -> Void {
        switch self.bottomSheetPosition {
        case .middle:
            self.bottomSheetPosition = .bottom
        case .bottom:
            self.bottomSheetPosition = .middle
        case .hidden:
            self.bottomSheetPosition = .hidden
        }
    }
    
    func switchPosition(with height: CGFloat) -> Void {
        if bottomSheetPosition != .hidden {
            if height <= -0.1 {
                self.bottomSheetPosition = .middle
            } else if height >= 0.1 {
                self.bottomSheetPosition = .bottom
            }
        }
    }
    
    func isBottom() -> Bool {
        return self.bottomSheetPosition == .bottom
    }
    
    func isHidden() -> Bool {
        return self.bottomSheetPosition == .hidden
    }
    
    
    enum BottomSheetPositions: CGFloat {
        case middle = 0.4, bottom = 0.125, hidden = 0
    }
    
    
    required init(bottomSheetPosition: BottomSheetPositions) {
        self.bottomSheetPosition = bottomSheetPosition
    }
}

//3 States: .hidden, .bottom, .top
class HBTBottomSheetPosition: BottomSheetPosition {
    
    var bottomSheetPosition: BottomSheetPositions
    
    
    func switchPositionIndicator() -> Void {
        switch self.bottomSheetPosition {
        case .top:
            self.bottomSheetPosition = .bottom
        case .bottom:
            self.bottomSheetPosition = .top
        case .hidden:
            self.bottomSheetPosition = .hidden
        }
    }
    
    func switchPosition(with height: CGFloat) -> Void {
        if bottomSheetPosition != .hidden {
            if height <= -0.1 {
                self.bottomSheetPosition = .top
            } else if height >= 0.1 {
                self.bottomSheetPosition = .bottom
            }
        }
    }
    
    func isBottom() -> Bool {
        return self.bottomSheetPosition == .bottom
    }
    
    func isHidden() -> Bool {
        return self.bottomSheetPosition == .hidden
    }
    
    
    enum BottomSheetPositions: CGFloat {
        case top = 0.975, bottom = 0.125, hidden = 0
    }
    
    
    required init(bottomSheetPosition: BottomSheetPositions) {
        self.bottomSheetPosition = bottomSheetPosition
    }
}

//3 States: .hidden, .middle, .top
class HMTBottomSheetPosition: BottomSheetPosition {
    
    var bottomSheetPosition: BottomSheetPositions
    
    
    func switchPositionIndicator() -> Void {
        switch self.bottomSheetPosition {
        case .top:
            self.bottomSheetPosition = .middle
        case .middle:
            self.bottomSheetPosition = .top
        case .hidden:
            self.bottomSheetPosition = .hidden
        }
    }
    
    func switchPosition(with height: CGFloat) -> Void {
        if bottomSheetPosition != .hidden {
            if height <= -0.1 {
                self.bottomSheetPosition = .top
            } else if height >= 0.1 {
                self.bottomSheetPosition = .middle
            }
        }
    }
    
    func isBottom() -> Bool {
        return false
    }
    
    func isHidden() -> Bool {
        return self.bottomSheetPosition == .hidden
    }
    
    
    enum BottomSheetPositions: CGFloat {
        case top = 0.975, middle = 0.4, hidden = 0
    }
    
    
    required init(bottomSheetPosition: BottomSheetPositions) {
        self.bottomSheetPosition = bottomSheetPosition
    }
}

//3 States: .bottom, .middle, .top
class BMTBottomSheetPosition: BottomSheetPosition {
    
    var bottomSheetPosition: BottomSheetPositions
    
    
    func switchPositionIndicator() -> Void {
        switch self.bottomSheetPosition {
        case .top:
            self.bottomSheetPosition = .middle
        case .middle:
            self.bottomSheetPosition = .top
        case .bottom:
            self.bottomSheetPosition = .middle
        }
    }
    
    func switchPosition(with height: CGFloat) -> Void {
        if height <= -0.1 && height > -0.3 {
            if self.bottomSheetPosition == .bottom {
                self.bottomSheetPosition = .middle
            } else {
                self.bottomSheetPosition = .top
            }
        } else if height <= -0.3 {
            self.bottomSheetPosition = .top
        } else if height >= 0.1 && height < 0.3 {
            if self.bottomSheetPosition == .top {
                self.bottomSheetPosition = .middle
            } else {
                self.bottomSheetPosition = .bottom
            }
        } else if height >= 0.3 {
            self.bottomSheetPosition = .bottom
        }
    }
    
    func isBottom() -> Bool {
        return self.bottomSheetPosition == .bottom
    }
    
    func isHidden() -> Bool {
        return false
    }
    
    
    enum BottomSheetPositions: CGFloat {
        case top = 0.975, middle = 0.4, bottom = 0.125
    }
    
    
    required init(bottomSheetPosition: BottomSheetPositions) {
        self.bottomSheetPosition = bottomSheetPosition
    }
}

//2 States: .hidden, .bottom
class HBBottomSheetPosition: BottomSheetPosition {
    
    var bottomSheetPosition: BottomSheetPositions
    
    
    func switchPositionIndicator() -> Void {
        //
    }
    
    func switchPosition(with height: CGFloat) -> Void {
        //
    }
    
    func isBottom() -> Bool {
        return self.bottomSheetPosition == .bottom
    }
    
    func isHidden() -> Bool {
        return self.bottomSheetPosition == .hidden
    }
    
    
    enum BottomSheetPositions: CGFloat {
        case bottom = 0.125, hidden = 0
    }
    
    
    required init(bottomSheetPosition: BottomSheetPositions) {
        self.bottomSheetPosition = bottomSheetPosition
    }
}

//2 States: .hidden, .middle
class HMBottomSheetPosition: BottomSheetPosition {
    
    var bottomSheetPosition: BottomSheetPositions
    
    
    func switchPositionIndicator() -> Void {
        //
    }
    
    func switchPosition(with height: CGFloat) -> Void {
        //
    }
    
    func isBottom() -> Bool {
        return false
    }
    
    func isHidden() -> Bool {
        return self.bottomSheetPosition == .hidden
    }
    
    
    enum BottomSheetPositions: CGFloat {
        case middle = 0.4, hidden = 0
    }
    
    
    required init(bottomSheetPosition: BottomSheetPositions) {
        self.bottomSheetPosition = bottomSheetPosition
    }
}

//2 States: .hidden, .top
class HTBottomSheetPosition: BottomSheetPosition {
    
    var bottomSheetPosition: BottomSheetPositions
    
    
    func switchPositionIndicator() -> Void {
        //
    }
    
    func switchPosition(with height: CGFloat) -> Void {
        //
    }
    
    func isBottom() -> Bool {
        return false
    }
    
    func isHidden() -> Bool {
        return self.bottomSheetPosition == .hidden
    }
    
    
    enum BottomSheetPositions: CGFloat {
        case top = 0.975, hidden = 0
    }
    
    
    required init(bottomSheetPosition: BottomSheetPositions) {
        self.bottomSheetPosition = bottomSheetPosition
    }
}

//2 States: .bottom, .middle
class BMBottomSheetPosition: BottomSheetPosition {
    
    var bottomSheetPosition: BottomSheetPositions
    
    
    func switchPositionIndicator() -> Void {
        switch self.bottomSheetPosition {
        case .middle:
            self.bottomSheetPosition = .bottom
        case .bottom:
            self.bottomSheetPosition = .middle
        }
    }
    
    func switchPosition(with height: CGFloat) -> Void {
        if height <= -0.1 {
            self.bottomSheetPosition = .middle
        } else if height >= 0.1 {
            self.bottomSheetPosition = .bottom
        }
    }
    
    func isBottom() -> Bool {
        return self.bottomSheetPosition == .bottom
    }
    
    func isHidden() -> Bool {
        return false
    }
    
    
    enum BottomSheetPositions: CGFloat {
        case middle = 0.4, bottom = 0.125
    }
    
    
    required init(bottomSheetPosition: BottomSheetPositions) {
        self.bottomSheetPosition = bottomSheetPosition
    }
}

//2 States: .bottom, .top
class BTBottomSheetPosition: BottomSheetPosition {
    
    var bottomSheetPosition: BottomSheetPositions
    
    
    func switchPositionIndicator() -> Void {
        switch self.bottomSheetPosition {
        case .top:
            self.bottomSheetPosition = .bottom
        case .bottom:
            self.bottomSheetPosition = .top
        }
    }
    
    func switchPosition(with height: CGFloat) -> Void {
        if height <= -0.1 {
            self.bottomSheetPosition = .top
        } else if height >= 0.1 {
            self.bottomSheetPosition = .bottom
        }
    }
    
    func isBottom() -> Bool {
        return self.bottomSheetPosition == .bottom
    }
    
    func isHidden() -> Bool {
        return false
    }
    
    
    enum BottomSheetPositions: CGFloat {
        case top = 0.975, bottom = 0.125
    }
    
    
    required init(bottomSheetPosition: BottomSheetPositions) {
        self.bottomSheetPosition = bottomSheetPosition
    }
}

//2 States: .middle, .top
class MTBottomSheetPosition: BottomSheetPosition {
    
    var bottomSheetPosition: BottomSheetPositions
    
    
    func switchPositionIndicator() -> Void {
        switch self.bottomSheetPosition {
        case .top:
            self.bottomSheetPosition = .middle
        case .middle:
            self.bottomSheetPosition = .top
        }
    }
    
    func switchPosition(with height: CGFloat) -> Void {
        if height <= -0.1 {
            self.bottomSheetPosition = .top
        } else if height >= 0.1 {
            self.bottomSheetPosition = .middle
        }
    }
    
    func isBottom() -> Bool {
        return false
    }
    
    func isHidden() -> Bool {
        return false
    }
    
    
    enum BottomSheetPositions: CGFloat {
        case top = 0.975, middle = 0.4
    }
    
    
    required init(bottomSheetPosition: BottomSheetPositions) {
        self.bottomSheetPosition = bottomSheetPosition
    }
}
