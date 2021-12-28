//
//  BSScrollView.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//

import SwiftUI

internal struct BSScrollView<Content: View>: View {
    
    @Binding private var isScrollEnabled: Bool
    
    private let defaultAxes: Axis.Set
    private let showsIndicators: Bool
    private let onOffsetChange: (CGPoint) -> Void
    private let content: Content
    
    private var axes: Axis.Set {
        return self.isScrollEnabled ? self.defaultAxes : []
    }
    
    
    internal var body: some View {
        ScrollView(self.axes, showsIndicators: self.showsIndicators) {
            GeometryReader { geometry in
                Color.clear
                    .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scrollView")).origin
                    )
            }
            .frame(width: 0, height: 0)
            self.content
                //.padding(.top, -8)
                .frame(maxWidth: .infinity, alignment: .top)
        }
        .coordinateSpace(name: "scrollView")
        .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: self.onOffsetChange)
    }
    
    
    internal init(axes: Axis.Set = .vertical, showsIndicators: Bool = true, isScrollEnabled: Binding<Bool> = .constant(true), onOffsetChange: @escaping (CGPoint) -> Void = { _ in }, @ViewBuilder content: () -> Content) {
        self.defaultAxes = axes
        self.showsIndicators = showsIndicators
        self._isScrollEnabled = isScrollEnabled
        self.onOffsetChange = onOffsetChange
        self.content = content()
    }
}

private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}

struct SwiftUIView_Previews: PreviewProvider {
    @State private static var isScrollEnabled: Bool = true
    
    static var previews: some View {
        ScrollView {
            ForEach(0...100, id: \.self) { i in
                Text("\(i)")
            }
        }

    }
}
