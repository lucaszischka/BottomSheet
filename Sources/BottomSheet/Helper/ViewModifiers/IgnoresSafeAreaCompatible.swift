//
//  IgnoresSafeAreaCompatible.swift
//  
//
//  Created by Chocoford on 2023/6/16.
//

import SwiftUI

internal enum SafeAreaRegionsCompatible {
    case all
    case container
    case keyboard
    
    @available(iOS 14.0, macOS 11.0, macCatalyst 14.0, *)
    var safeAreaRegions: SafeAreaRegions {
        switch self {
        case .all:
            return .all
        case .container:
            return .container
        case .keyboard:
            return .keyboard
        }
    }
}

internal extension View {
    @ViewBuilder
    func ignoresSafeAreaCompatible(
        _ regions: SafeAreaRegionsCompatible = .all,
        edges: Edge.Set = .all
    ) -> some View {
        if #available(iOS 14.0, macOS 11.0, *) {
            ignoresSafeArea(
                regions.safeAreaRegions,
                edges: edges
            )
        } else {
            edgesIgnoringSafeArea(edges)
        }
    }
}
