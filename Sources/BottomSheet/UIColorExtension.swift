//
//  UIColorExtension.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//

import SwiftUI

/// Color definitions of the UIColor constant colors.
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension Color {
    #if !os(watchOS) // watchOS doesn't support adaptable colors.
    // Adaptable colors
    public static let systemRed = Color(UIColor.systemRed)
    public static let systemGreen = Color(UIColor.systemGreen)
    public static let systemBlue = Color(UIColor.systemBlue)
    public static let systemOrange = Color(UIColor.systemOrange)
    public static let systemYellow = Color(UIColor.systemYellow)
    public static let systemPink = Color(UIColor.systemPink)
    public static let systemPurple = Color(UIColor.systemPurple)
    public static let systemTeal = Color(UIColor.systemTeal)
    public static let systemIndigo = Color(UIColor.systemIndigo)
    
    // Adaptable grayscales
    public static let systemGray = Color(UIColor.systemGray)
    #if !os(tvOS) // tvOS doesn't have the adaptable gray shades, just the primary color.
    public static let systemGray2 = Color(UIColor.systemGray2)
    public static let systemGray3 = Color(UIColor.systemGray3)
    public static let systemGray4 = Color(UIColor.systemGray4)
    public static let systemGray5 = Color(UIColor.systemGray5)
    public static let systemGray6 = Color(UIColor.systemGray6)
    #endif //!tvOS
    
    // Adaptable text colors
    public static let label = Color(UIColor.label)
    public static let secondaryLabel = Color(UIColor.secondaryLabel)
    public static let tertiaryLabel = Color(UIColor.tertiaryLabel)
    public static let quaternaryLabel = Color(UIColor.quaternaryLabel)
    public static let link = Color(UIColor.link)
    public static let placeholderText = Color(UIColor.placeholderText)
    
    // Adaptable separators
    public static let separator = Color(UIColor.separator)
    public static let opaqueSeparator = Color(UIColor.opaqueSeparator)
    
    #if !os(tvOS) // tvOS supports the above adaptable colors, but not these. 🤷‍♂️
    // Adaptable backgrounds
    public static let systemBackground = Color(UIColor.systemBackground)
    public static let secondarySystemBackground = Color(UIColor.secondarySystemBackground)
    public static let tertiarySystemBackground = Color(UIColor.tertiarySystemBackground)
    
    
    // Adaptable grouped backgrounds
    public static let systemGroupedBackground = Color(UIColor.systemGroupedBackground)
    public static let secondarySystemGroupedBackground = Color(UIColor.secondarySystemGroupedBackground)
    public static let tertiarySystemGroupedBackground = Color(UIColor.tertiarySystemGroupedBackground)
    
    // Adaptable system fills
    public static let systemFill = Color(UIColor.systemFill)
    public static let secondarySystemFill = Color(UIColor.secondarySystemFill)
    public static let tertiarySystemFill = Color(UIColor.tertiarySystemFill)
    public static let quaternarySystemFill = Color(UIColor.quaternarySystemFill)
    #endif // !tvOS
    #endif // !watchOS
    
    // "Fixed" colors
    // Some of these clash with existing Color names: compare Color.blue (0.22, 0.57, 0.97) in the light theme to
    // UIColor.blue (0.01, 0.19, 0.97) to see two very different shades of blue. For that matter the adaptable
    // UIColor.systemBlue in the light theme (0.25, 0.56, 0.97) isn't *quite* the same blue as Color.blue either.
    
    //So all of the UIColor "fixed" colors are here with "fixed" prepended to the color name.
    public static let fixedBlack = Color(UIColor.black)
    public static let fixedDarkGray = Color(UIColor.darkGray)
    public static let fixedLightGray = Color(UIColor.lightGray)
    public static let fixedWhite = Color(UIColor.white)
    public static let fixedGray = Color(UIColor.gray)
    public static let fixedRed = Color(UIColor.red)
    public static let fixedGreen = Color(UIColor.green)
    public static let fixedBlue = Color(UIColor.blue)
    public static let fixedCyan = Color(UIColor.cyan)
    public static let fixedYellow = Color(UIColor.yellow)
    public static let fixedMagenta = Color(UIColor.magenta)
    public static let fixedOrange = Color(UIColor.orange)
    public static let fixedPurple = Color(UIColor.purple)
    public static let fixedBrown = Color(UIColor.brown)
    public static let fixedClear = Color(UIColor.clear)
    
    // There are a few more predefined UIColors that could go here. groupTableViewBackground is formally deprecated
    // in favor of systemGroupedBackground so I didn't include it. lightText and darkText are not formally deprecated,
    // but there is a comment recommending replacing them with label and related colors so I didn't add them to this
    // list.
}
