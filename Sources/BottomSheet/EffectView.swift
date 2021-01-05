//
//  EffectView.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//

import SwiftUI

struct EffectView: UIViewRepresentable {

    var effect: UIVisualEffect
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let effectView = UIVisualEffectView(effect: self.effect)
        
        return effectView
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        //
    }
}

struct EffectView_Previews: PreviewProvider {
    static var previews: some View {
        EffectView(effect: UIBlurEffect(style: .regular))
    }
}
