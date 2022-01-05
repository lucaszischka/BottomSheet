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
    private let onChanged: (ClearDragGestureView.Value) -> Void
    private let onEnded: (ClearDragGestureView.Value) -> Void
    private let content: Content
    
    private var axes: Axis.Set {
        return self.isScrollEnabled ? self.defaultAxes : []
    }
    
    
    internal var body: some View {
        ScrollView(self.axes, showsIndicators: self.showsIndicators) {
            self.content
                .overlay(
                    ClearDragGestureView(onChanged: self.onChanged, onEnded: self.onEnded)
                )
        }
    }
    
    
    internal init(axes: Axis.Set = .vertical, showsIndicators: Bool = true, isScrollEnabled: Binding<Bool> = .constant(true), onChanged: @escaping (ClearDragGestureView.Value) -> Void = { _ in}, onEnded: @escaping (ClearDragGestureView.Value) -> Void = { _ in}, @ViewBuilder content: () -> Content) {
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
