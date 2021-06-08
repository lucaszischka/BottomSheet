//
//  EffectView.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//

import SwiftUI

internal struct EffectView: UIViewRepresentable {

    internal var effect: UIVisualEffect
    
    
    internal func makeUIView(context: Context) -> UIVisualEffectView {
        let effectView = UIVisualEffectView(effect: self.effect)
        
        return effectView
    }
    
    internal func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = self.effect
    }
}

struct EffectView_Previews: PreviewProvider {
    static var previews: some View {
        EffectView(effect: UIBlurEffect(style: .regular))
    }
}
