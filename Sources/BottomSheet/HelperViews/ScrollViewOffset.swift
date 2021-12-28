//
//  ScrollViewOffset.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//

import SwiftUI

internal struct ScrollViewOffset<Content: View>: View {
    
    private let onOffsetChange: (CGFloat) -> Void
    private let content: () -> Content
    
    private var offsetReader: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(
                    key: OffsetPreferenceKey.self,
                    value: proxy.frame(in: .named("frameLayer")).minY
                )
        }
        .frame(height: 0)
    }
    
    
    internal var body: some View {
        ScrollView {
            offsetReader
            content()
                .padding(.top, -8)
        }
        .coordinateSpace(name: "frameLayer")
        .onPreferenceChange(OffsetPreferenceKey.self, perform: onOffsetChange)
    }
    
    
    internal init(onOffsetChange: @escaping (CGFloat) -> Void, @ViewBuilder content: @escaping () -> Content ) {
        self.onOffsetChange = onOffsetChange
        self.content = content
    }
}

private struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

struct ScrollViewOffset_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewOffset(onOffsetChange: { offset in }) {
            ForEach(0...100, id: \.self) { i in
                Text("\(i)")
            }
        }
    }
}
