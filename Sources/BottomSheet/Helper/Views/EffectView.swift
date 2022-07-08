//
//  EffectView.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

// TODO: Make EffectView cross platform (could remove a couple of os checks)
#if os(macOS)
import AppKit

public struct EffectView: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    
    public func makeNSView(
        context: Context
    ) -> NSVisualEffectView {
        let effectView = NSVisualEffectView()
        effectView.material = self.material
        effectView.blendingMode = .withinWindow
        return effectView
    }
    
    public func updateNSView(
        _ nsView: NSVisualEffectView,
        context: Context
    ) {
        nsView.material = self.material
    }
}
#else
public struct EffectView: UIViewRepresentable {
    var material: UIBlurEffect.Style
    
    public func makeUIView(
        context: Context
    ) -> UIVisualEffectView {
        let effectView = UIVisualEffectView()
        effectView.effect = UIBlurEffect(
            style: self.material
        )
        return effectView
    }
    
    public func updateUIView(
        _ uiView: UIVisualEffectView,
        context: Context
    ) {
        uiView.effect = UIBlurEffect(
            style: self.material
        )
    }
}
#endif
