//
//  VisualEffectView.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

// Adapted from https://github.com/AlanQuatermain/AQUI/blob/master/Sources/AQUI/VisualEffectView.swift
#if canImport(UIKit)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// Describes a visual effect to be applied to the background of a view, typically to provide
/// a blurred rendition of the content below the view in z-order.
public enum VisualEffect: Equatable, Hashable {
    /// The material types available for the effect.
    ///
    /// On iOS this uses material types to specify the desired effect, while on
    /// macOS the materials are specified semantically based on their expected use case.
    public enum Material: Equatable, Hashable {
        /// A default appearance, suitable for most cases.
        case `default`
        
        /// A blur simulating a very thin material.
        @available(iOS 13.0, *)
        @available(macOS, unavailable)
        case ultraThin
        
        /// A blur simulating a thin material.
        @available(iOS 13.0, *)
        @available(macOS, unavailable)
        case thin
        
        /// A blur simulating a thicker than normal material.
        @available(iOS 13.0, *)
        @available(macOS, unavailable)
        case thick
        
        /// A blur matching the system chrome.
        @available(iOS 13.0, *)
        @available(macOS, unavailable)
        case chrome
        
        /// A material suitable for a window titlebar.
        @available(macOS 10.15, *)
        @available(iOS, unavailable)
        @available(macCatalyst, unavailable)
        case titlebar
        
        /// A material used for the background of a window.
        @available(macOS 10.15, *)
        @available(iOS, unavailable)
        @available(macCatalyst, unavailable)
        case windowBackground
        
        /// A material used for an inline header view.
        /// - Parameter behindWindow: `true` if the effect should use
        ///     the content behind the window, `false` to use content within
        ///     the window at a lower z-order.
        @available(macOS 10.15, *)
        @available(iOS, unavailable)
        @available(macCatalyst, unavailable)
        case headerView(behindWindow: Bool)
        
        /// A material used for the background of a content view, e.g. a scroll
        /// view or a list.
        /// - Parameter behindWindow: `true` if the effect should use
        ///     the content behind the window, `false` to use content within
        ///     the window at a lower z-order.
        @available(macOS 10.15, *)
        @available(iOS, unavailable)
        @available(macCatalyst, unavailable)
        case contentBackground(behindWindow: Bool)
        
        /// A material used for the background of a view that contains a
        /// 'page' interface, as in some document-based applications.
        /// - Parameter behindWindow: `true` if the effect should use
        ///     the content behind the window, `false` to use content within
        ///     the window at a lower z-order.
        @available(macOS 10.15, *)
        @available(iOS, unavailable)
        @available(macCatalyst, unavailable)
        case behindPageBackground(behindWindow: Bool)
    }
    
    /// A standard effect that adapts to the current `ColorScheme`.
    case system
    /// A standard effect that uses the system light appearance.
    case systemLight
    /// A standard effect that uses the system dark appearance.
    case systemDark
    
    /// An adaptive effect with the given material that changes to match
    /// the current `ColorScheme`.
    case adaptive(Material)
    /// An effect that uses the given material with the system light appearance.
    case light(Material)
    /// An effect that uses the given material with the system dark appearance.
    case dark(Material)
}

#if os(iOS) || targetEnvironment(macCatalyst)
fileprivate extension VisualEffect {
    var blurStyle: UIBlurEffect.Style {
        switch self {
        case .system:      return .systemMaterial
        case .systemLight: return .systemMaterialLight
        case .systemDark:  return .systemMaterialDark
        case .adaptive(let material):
            switch material {
            case .ultraThin:    return .systemUltraThinMaterial
            case .thin:         return .systemThinMaterial
            case .default:      return .systemMaterial
            case .thick:        return .systemThickMaterial
            case .chrome:       return .systemChromeMaterial
            }
        case .light(let material):
            switch material {
            case .ultraThin:    return .systemUltraThinMaterialLight
            case .thin:         return .systemThinMaterialLight
            case .default:      return .systemMaterialLight
            case .thick:        return .systemThickMaterialLight
            case .chrome:       return .systemChromeMaterialLight
            }
        case .dark(let material):
            switch material {
            case .ultraThin:    return .systemUltraThinMaterialDark
            case .thin:         return .systemThinMaterialDark
            case .default:      return .systemMaterialDark
            case .thick:        return .systemThickMaterialDark
            case .chrome:       return .systemChromeMaterialDark
            }
        }
    }
}
#elseif os(macOS)
fileprivate extension VisualEffect {
    var material: NSVisualEffectView.Material {
        switch self {
        case .system, .systemLight, .systemDark:
            return .contentBackground
        case .adaptive(let material), .light(let material), .dark(let material):
            switch material {
            case .default, .contentBackground: return .contentBackground
            case .titlebar: return .titlebar
            case .headerView: return .headerView
            case .behindPageBackground: return .underPageBackground
            case .windowBackground: return .windowBackground
            }
        }
    }
    
    var blendingMode: NSVisualEffectView.BlendingMode {
        switch self {
        case .system, .systemLight, .systemDark:
            return .behindWindow
        case .adaptive(let material),
                .light(let material),
                .dark(let material):
            switch material {
            case .default, .windowBackground:
                return .behindWindow
            case .titlebar:
                return .withinWindow
            case .contentBackground(let behindWindow),
                    .headerView(let behindWindow),
                    .behindPageBackground(let behindWindow):
                return behindWindow ? .behindWindow : .withinWindow
            }
        }
    }
    
    var appearance: NSAppearance? {
        switch self {
        case .system, .adaptive:      return nil
        case .systemLight, .light: return NSAppearance(named: .aqua)
        case .systemDark, .dark:  return NSAppearance(named: .darkAqua)
        }
    }
}
#endif

#if os(macOS)
internal struct VisualEffectView: NSViewRepresentable {
    
    var visualEffect: VisualEffect
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = self.visualEffect.material
        view.blendingMode = self.visualEffect.blendingMode
        view.appearance = self.visualEffect.appearance
        
        // mark emphasized if it contains the first responder
        if let resp = view.window?.firstResponder as? NSView {
            view.isEmphasized = resp === view || resp.isDescendant(
                of: view
            )
        } else {
            view.isEmphasized = false
        }
        view.autoresizingMask = [
            .width,
            .height
        ]
        return view
    }
    
    func updateNSView(
        _ nsView: NSVisualEffectView,
        context: Context
    ) {
        nsView.material = self.visualEffect.material
        nsView.blendingMode = self.visualEffect.blendingMode
        nsView.appearance = self.visualEffect.appearance
        
        // mark emphasized if it contains the first responder
        if let resp = nsView.window?.firstResponder as? NSView {
            nsView.isEmphasized = resp === nsView || resp.isDescendant(of: nsView)
        } else {
            nsView.isEmphasized = false
        }
    }
}
#elseif canImport(UIKit)
internal struct VisualEffectView: UIViewRepresentable {
    
    var visualEffect: VisualEffect
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: self.visualEffect.blurStyle))
        view.autoresizingMask = [
            .flexibleWidth,
            .flexibleHeight
        ]
        return view
    }
    
    func updateUIView(
        _ uiView: UIVisualEffectView,
        context: Context
    ) {
        uiView.effect = UIBlurEffect(style: self.visualEffect.blurStyle)
    }
}
#endif
