//
//  OrientationHelper.swift
//  BottomSheet
//
//  Created by Pedro Cavaleiro on 27/08/2025.
//

#if os(iOS)
import UIKit

enum BundleOrientationLock {
    case portraitOnly
    case landscapeOnly
    case unlocked
}

func bundleOrientationLock() -> BundleOrientationLock {
    let info = Bundle.main.infoDictionary

    // Grab iPhone orientations first, fallback to iPad
    let iPhoneOrientations = info?["UISupportedInterfaceOrientations"] as? [String] ?? []
    let iPadOrientations = info?["UISupportedInterfaceOrientations~ipad"] as? [String] ?? []

    let orientations = !iPhoneOrientations.isEmpty ? iPhoneOrientations : iPadOrientations

    // Map strings into orientation masks
    let masks: [UIInterfaceOrientationMask] = orientations.compactMap { str in
        switch str {
        case "UIInterfaceOrientationPortrait":
            return .portrait
        case "UIInterfaceOrientationPortraitUpsideDown":
            return .portraitUpsideDown
        case "UIInterfaceOrientationLandscapeLeft":
            return .landscapeLeft
        case "UIInterfaceOrientationLandscapeRight":
            return .landscapeRight
        default:
            return nil
        }
    }

    if masks.count == 1 {
        if masks.contains(.portrait) || masks.contains(.portraitUpsideDown) {
            return .portraitOnly
        } else if masks.contains(.landscapeLeft) || masks.contains(.landscapeRight) {
            return .landscapeOnly
        }
    }

    return .unlocked
}

#endif
