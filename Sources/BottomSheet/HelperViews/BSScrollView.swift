//
//  BSScrollView.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021-2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

internal struct BSScrollView<Content: View>: View {
    
    @Binding private var isScrollEnabled: Bool
    
    private let defaultAxes: Axis.Set
    private let showsIndicators: Bool
    private let onChanged: (DragGestureView.Value) -> Void
    private let onEnded: (DragGestureView.Value) -> Void
    private let content: Content
    
    private var axes: Axis.Set {
        return self.isScrollEnabled ? self.defaultAxes : []
    }
    
    
    var body: some View {
        ScrollView(self.axes, showsIndicators: self.showsIndicators) {
            self.content
                .dragGesture(onChanged: self.onChanged, onEnded: self.onEnded)
        }
    }
    
    
    init(axes: Axis.Set = .vertical, showsIndicators: Bool = true, isScrollEnabled: Binding<Bool> = .constant(true), onChanged: @escaping (DragGestureView.Value) -> Void = { _ in}, onEnded: @escaping (DragGestureView.Value) -> Void = { _ in}, @ViewBuilder content: () -> Content) {
        self._isScrollEnabled = isScrollEnabled
        
        self.defaultAxes = axes
        self.showsIndicators = showsIndicators
        self.onChanged = onChanged
        self.onEnded = onEnded
        self.content = content()
    }
}

struct BSScrollView_Previews: PreviewProvider {
    static var previews: some View {
        BSScrollView {
            ForEach(0...100, id: \.self) { i in
                Text("\(i)")
            }
        }
    }
}
