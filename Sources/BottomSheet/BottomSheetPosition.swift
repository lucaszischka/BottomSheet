//
//  BottomSheetPosition.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//

import SwiftUI

/**
The default BottomSheetPosition; it has the following cases and values: `top = 0.975`,  `middle = 0.4`,  `bottom = 0.125`,  `hidden = 0`
 
You can create your own custom BottomSheetPosition enum:
   - The enum must be conforming to `CGFloat` and `CaseIterable`
   - The case and enum name doesnt matter
   - The case/state with `rawValue == 0` is hiding the BottomSheet
   - The value can be anythig between `0` and `1` (`x <= 1`, `x >= 0`)
   - The value is the height of the BottomSheet propotional to the screen height (`1 == 100% == full screen`)
   - The lowest value (greater than 0) automaticly gets the `.bottom` behavior. To prevent this please use the option `.noBottomPosition`
*/
public enum BottomSheetPosition: CGFloat, CaseIterable {
    //The state where the height of the BottomSheet is 97.5%
    case top = 0.975
    //The state where the height of the BottomSheet is 40%
    case middle = 0.4
    //The state where the height of the BottomSheet is 12.5% and the `mainContent` is hidden
    case bottom = 0.125
    //The state where the BottomSheet is hidden
    case hidden = 0
}
