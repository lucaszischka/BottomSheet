//
//  ViewExtension.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//

import SwiftUI

public extension View {
    func bottomSheet<hContent: View, mContent: View>(bottomSheetPosition: Binding<BottomSheetPosition>, resizeable: Bool = true, showCancelButton: Bool = false, @ViewBuilder headerContent: () -> hContent?, @ViewBuilder mainContent: () -> mContent, closeAction: @escaping () -> () = {}) -> some View {
        ZStack {
            self
            BottomSheetView(bottomSheetPosition: bottomSheetPosition, resizeable: resizeable, showCancelButton: showCancelButton, headerContent: headerContent, mainContent: mainContent, closeAction: closeAction)
        }
    }
    
    func bottomSheet<mContent: View>(bottomSheetPosition: Binding<BottomSheetPosition>, resizeable: Bool = true, showCancelButton: Bool = false, title: String? = nil, @ViewBuilder content: () -> mContent, closeAction: @escaping () -> () = {}) -> some View {
        ZStack {
            self
            BottomSheetView(bottomSheetPosition: bottomSheetPosition, resizeable: resizeable, showCancelButton: showCancelButton, title: title, content: content, closeAction: closeAction)
        }
    }
}
