//
//  BottomSheetPosition.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021-2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

/**
 The default BottomSheetPosition; it has the following cases and values: `top = 0.975`,  `middle = 0.4`,  `bottom = 0.125`,  `hidden = 0`.
 
 This BottomSheetPosition uses relative values. For absolute values in pixels, see BottomSheetPositionAbsolute.
 
 You can create your own custom BottomSheetPosition enum:
 - The enum must be conforming to `CGFloat`, `CaseIterable` and `Equatable`
 - The enum and case names doesnt matter
 - The case/state with `rawValue == 0` is hiding the BottomSheet
 - The value can be anythig between `0` and `1` (`x <= 1`, `x >= 0`) or anything above `0` (`x >= 0`) when using the`.absolutePositionValue` option
 - The value is the height of the BottomSheet propotional to the screen height (`1 == 100% == full screen`) or the height of the BottomSheet in pixel (`1 == 1px`) when using the`.absolutePositionValue` option
 - The lowest value (greater than 0) automaticly gets the `.bottom` behavior. To prevent this please use the option `.noBottomPosition`
 */
public enum BottomSheetPosition: CGFloat, CaseIterable, Equatable {
    ///The state where the height of the BottomSheet is 97.5%
    case top = 0.975
    ///The state where the height of the BottomSheet is 40%
    case middle = 0.4
    ///The state where the height of the BottomSheet is 12.5% and the `mainContent` is hidden
    case bottom = 0.125
    ///The state where the BottomSheet is hidden
    case hidden = 0
}

/**
 The default BottomSheetPositionAbsolute; it has the following cases and values: `top = 750`,  `middle = 300`,  `bottom = 100`,  `hidden = 0`.
 
 This BottomSheetPositionAbsolute uses absolute values and requires the the`.absolutePositionValue` option. For relative values in pixels, see BottomSheetPosition.
 
 You can create your own custom BottomSheetPosition enum:
 - The enum must be conforming to `CGFloat`, `CaseIterable` and `Equatable`
 - The enum and case names doesnt matter
 - The case/state with `rawValue == 0` is hiding the BottomSheet
 - The value can be anythig between `0` and `1` (`x <= 1`, `x >= 0`) or anything above `0` (`x >= 0`) when using the`.absolutePositionValue` option
 - The value is the height of the BottomSheet propotional to the screen height (`1 == 100% == full screen`) or the height of the BottomSheet in pixel (`1 == 1px`) when using the`.absolutePositionValue` option
 - The lowest value (greater than 0) automaticly gets the `.bottom` behavior. To prevent this please use the option `.noBottomPosition`
 */
public enum BottomSheetPositionAbsolute: CGFloat, CaseIterable, Equatable {
    ///The state where the height of the BottomSheet is 750px
    case top = 750
    ///The state where the height of the BottomSheet is 300px
    case middle = 300
    ///The state where the height of the BottomSheet is 100px and the `mainContent` is hidden
    case bottom = 100
    ///The state where the BottomSheet is hidden
    case hidden = 0
}
