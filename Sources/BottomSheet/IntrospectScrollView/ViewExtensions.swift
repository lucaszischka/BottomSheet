//
//  ViewExtensions.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//

import SwiftUI

extension View {
    public func inject<SomeView>(_ view: SomeView) -> some View where SomeView: View {
        overlay(view.frame(width: 0, height: 0))
    }
    
    /// Finds a `TargetView` from a `SwiftUI.View`
    public func introspect<TargetView: UIView>(
        selector: @escaping (IntrospectionUIView) -> TargetView?,
        customize: @escaping (TargetView) -> ()
    ) -> some View {
        inject(UIKitIntrospectionView(
            selector: selector,
            customize: customize
        ))
    }
    
    /// Finds a `UIScrollView` from a `SwiftUI.ScrollView`, or `SwiftUI.ScrollView` child.
    public func introspectScrollView(customize: @escaping (UIScrollView) -> ()) -> some View {
        if #available(iOS 14.0, tvOS 14.0, macOS 11.0, *) {
            return introspect(selector: TargetViewSelector.siblingOfTypeOrAncestor, customize: customize)
        } else {
            return introspect(selector: TargetViewSelector.siblingContainingOrAncestor, customize: customize)
        }
    }
}
