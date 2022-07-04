//
//  MeasureSizeModifier.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

internal extension View {
    func measureSize(
        onChange: @escaping (
            CGSize
        ) -> Void
    ) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(
                        key: SizePreferenceKey.self,
                        value: geometryProxy.size
                    )
            }
        )
            .onPreferenceChange(
                SizePreferenceKey.self,
                perform: onChange
            )
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(
        value: inout CGSize,
        nextValue: () -> CGSize
    ) {}
}
