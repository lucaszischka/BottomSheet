//
//  EffectView.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// Describes a visual effect to be applied to the background of a view, typically to provide
/// a blurred rendition of the content below the view in z-order.
@available(macOS 10.15, iOS 13.0, *)
public enum VisualEffect: Equatable, Hashable {
    /// The material types available for the effect.
    ///
    /// On iOS and tvOS, this uses material types to specify the desired effect, while on
    /// macOS the materials are specified semantically based on their expected use case.
    public enum Material: Equatable, Hashable {
        /// A default appearance, suitable for most cases.
        @available(macOS 10.15, iOS 13.0, *)
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
        case headerView(
            behindWindow: Bool
        )
        
        /// A material used for the background of a content view, e.g. a scroll
        /// view or a list.
        /// - Parameter behindWindow: `true` if the effect should use
        ///     the content behind the window, `false` to use content within
        ///     the window at a lower z-order.
        @available(macOS 10.15, *)
        @available(iOS, unavailable)
        @available(macCatalyst, unavailable)
        case contentBackground(
            behindWindow: Bool
        )
        
        /// A material used for the background of a view that contains a
        /// 'page' interface, as in some document-based applications.
        /// - Parameter behindWindow: `true` if the effect should use
        ///     the content behind the window, `false` to use content within
        ///     the window at a lower z-order.
        @available(macOS 10.15, *)
        @available(iOS, unavailable)
        @available(macCatalyst, unavailable)
        case behindPageBackground(
            behindWindow: Bool
        )
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
extension VisualEffect {
    /// Vends an appropriate `UIVisualEffect`.
    var parameters: UIVisualEffect {
        UIBlurEffect(
            style: self.blurStyle
        )
    }
    
    private var blurStyle: UIBlurEffect.Style {
        switch self {
        case .system:
            return .systemMaterial
        case .systemLight:
            return .systemMaterialLight
        case .systemDark:
            return .systemMaterialDark
        case .adaptive(
            let material
        ):
            switch material {
            case .ultraThin:
                return .systemUltraThinMaterial
            case .thin:
                return .systemThinMaterial
            case .default:
                return .systemMaterial
            case .thick:
                return .systemThickMaterial
            case .chrome:
                return .systemChromeMaterial
            }
        case .light(let material):
            switch material {
            case .ultraThin:
                return .systemUltraThinMaterialLight
            case .thin:
                return .systemThinMaterialLight
            case .default:
                return .systemMaterialLight
            case .thick:
                return .systemThickMaterialLight
            case .chrome:
                return .systemChromeMaterialLight
            }
        case .dark(let material):
            switch material {
            case .ultraThin:
                return .systemUltraThinMaterialDark
            case .thin:
                return .systemThinMaterialDark
            case .default:
                return .systemMaterialDark
            case .thick:
                return .systemThickMaterialDark
            case .chrome:
                return .systemChromeMaterialDark
            }
        }
    }
}
#elseif os(macOS)
extension VisualEffect {
    /// A type describing the values passed to an `NSVisualEffectView`.
    struct NSEffectParameters {
        var material: NSVisualEffectView.Material = .contentBackground
        var blendingMode: NSVisualEffectView.BlendingMode = .behindWindow
        var appearance: NSAppearance?
    }
    
    /// Vends an appropriate `NSEffectParameters`.
    var parameters: NSEffectParameters {
        switch self {
        case .system:
            return NSEffectParameters()
        case .systemLight:
            return NSEffectParameters(
                appearance: NSAppearance(
                    named: .aqua
                )
            )
        case .systemDark:
            return NSEffectParameters(
                appearance: NSAppearance(
                    named: .darkAqua
                )
            )
        case .adaptive:
            return NSEffectParameters(
                material: self.material,
                blendingMode: self.blendingMode
            )
        case .light:
            return NSEffectParameters(
                material: self.material,
                blendingMode: self.blendingMode,
                appearance: NSAppearance(
                    named: .aqua
                )
            )
        case .dark:
            return NSEffectParameters(
                material: self.material,
                blendingMode: self.blendingMode,
                appearance: NSAppearance(
                    named: .darkAqua
                )
            )
        }
    }
    
    private var material: NSVisualEffectView.Material {
        switch self {
        case .system, .systemLight, .systemDark:
            return .contentBackground
        case .adaptive(let material), .light(let material), .dark(let material):
            switch material {
            case .default, .contentBackground:
                return .contentBackground
            case .titlebar:
                return .titlebar
            case .headerView:
                return .headerView
            case .behindPageBackground:
                return .underPageBackground
            case .windowBackground:
                return .windowBackground
            }
        }
    }
    
    private var blendingMode: NSVisualEffectView.BlendingMode {
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
            case .contentBackground(let background),
                    .headerView(let background),
                    .behindPageBackground(let background):
                return background ? .behindWindow : .withinWindow
            }
        }
    }
}
#endif

@available(OSX 10.15, iOS 13.0, tvOS 13.0, macCatalyst 13.0, *)
@available(watchOS, unavailable)
internal struct VisualEffectView: View {
    @State private var effect: VisualEffect?
    private let content: _PlatformVisualEffectView
    
    var body: some View {
        content
            .environment(
                \.visualEffect,
                 effect
            )
            .onPreferenceChange(
                VisualEffectPreferenceKey.self
            ) {
                self.effect = $0
            }
    }
    
    init(
        effect: VisualEffect
    ) {
        self._effect = State(
            wrappedValue: effect
        )
        self.content = _PlatformVisualEffectView()
    }
    
#if os(macOS)
    private struct _PlatformVisualEffectView: NSViewRepresentable {
        func makeNSView(
            context: Context
        ) -> NSVisualEffectView {
            let view = NSVisualEffectView()
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
            guard let params = context.environment.visualEffect?.parameters else {
                // disable the effect
                nsView.isHidden = true
                return
            }
            nsView.isHidden = false
            nsView.material = params.material
            nsView.blendingMode = params.blendingMode
            nsView.appearance = params.appearance
            
            // mark emphasized if it contains the first responder
            if let resp = nsView.window?.firstResponder as? NSView {
                nsView.isEmphasized = resp === nsView || resp.isDescendant(
                    of: nsView
                )
            } else {
                nsView.isEmphasized = false
            }
        }
    }
#elseif canImport(UIKit)
    private struct _PlatformVisualEffectView: UIViewRepresentable {
        func makeUIView(
            context: Context
        ) -> UIVisualEffectView {
            let effect = context.environment.visualEffect ?? .system
            
            let view = UIVisualEffectView(
                effect: effect.parameters
            )
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
            guard let effect = context.environment.visualEffect else {
                // disable the effect
                uiView.isHidden = true
                return
            }
            
            uiView.isHidden = false
            uiView.effect = effect.parameters
        }
    }
#endif
}

private struct VisualEffectKey: EnvironmentKey {
    static var defaultValue: VisualEffect?
}

private extension EnvironmentValues {
    var visualEffect: VisualEffect? {
        get {
            self[
                VisualEffectKey.self
            ]
        }
        set {
            self[
                VisualEffectKey.self
            ] = newValue
        }
    }
}

private struct VisualEffectPreferenceKey: PreferenceKey {
    static var defaultValue: VisualEffect?
    
    static func reduce(
        value: inout VisualEffect?,
        nextValue: () -> VisualEffect?
    ) {
        guard value == nil else {
            return
        }
        value = nextValue()
    }
}
