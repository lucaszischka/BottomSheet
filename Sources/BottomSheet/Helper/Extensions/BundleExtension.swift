//
//  BundleExtension.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

#if !SWIFT_PACKAGE
import Foundation

private class BundleFinder {}

internal extension Bundle {
    /// Returns the resource bundle associated with the current Swift module.
    static var module: Bundle = {
        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,

            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: BundleFinder.self).resourceURL,

            // For command-line tools.
            Bundle.main.bundleURL
        ]
        
        let bundleName = "BottomSheet_BottomSheet"

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        
        // Return whatever bundle this code is in as a last resort.
        return Bundle(for: BundleFinder.self)
    }()
}
#endif
