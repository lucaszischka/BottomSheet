//
//  BindingExtension.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//

import SwiftUI

internal extension Binding {
    /// Wrapper to listen to didSet of Binding
    func didSet(_ didSet: @escaping ((newValue: Value, oldValue: Value)) -> Void) -> Binding<Value> {
        return .init(get: { self.wrappedValue }, set: { newValue in
            let oldValue = self.wrappedValue
            self.wrappedValue = newValue
            didSet((newValue, oldValue))
        })
    }
}
