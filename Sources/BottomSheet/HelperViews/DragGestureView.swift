//
//  DragGestureView.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021-2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

//Adapted from https://stackoverflow.com/a/57943387/13467238

///A dragging motion that invokes an action as the drag-event sequence changes.
internal struct DragGestureView: UIViewRepresentable {
    ///Adds an action to perform when the gesture’s value changes.
    fileprivate let onChanged: (DragGestureView.Value) -> Void
    ///Adds an action to perform when the gesture ends.
    fileprivate let onEnded: (DragGestureView.Value) -> Void
    
    ///The attributes of a drag gesture.
    internal struct Value {
        ///The location of the drag gesture’s current event.
        let location: CGPoint
        
        ///A prediction, based on the current drag velocity, of where the final location will be if dragging stopped now.
        var predictedEndLocation: CGPoint {
            let endTranslation = predictedEndTranslation
            return CGPoint(x: location.x + endTranslation.width, y: location.y + endTranslation.height)
        }
        
        ///A prediction, based on the current drag velocity, of what the final translation will be if dragging stopped now.
        var predictedEndTranslation: CGSize {
            return CGSize(width: estimatedTranslation(fromVelocity: velocity.x), height: estimatedTranslation(fromVelocity: velocity.y))
        }
        
        ///The location of the drag gesture’s first event.
        let startLocation: CGPoint
        
        ///The time associated with the drag gesture’s current event.
        let time: Date
        
        ///The total translation from the start of the drag gesture to the current event of the drag gesture.
        var translation: CGSize {
            return CGSize(width: location.x - startLocation.x, height: location.y - startLocation.y)
        }
        
        
        fileprivate let velocity: CGPoint
        
        private func estimatedTranslation(fromVelocity velocity: CGFloat) -> CGFloat {
            //This is a guess. I couldn't find any documentation anywhere on what this should be
            let acceleration: CGFloat = 500
            let timeToStop = velocity / acceleration
            return velocity * timeToStop / 2
        }
    }
    
    
    func makeCoordinator() -> DragGestureView.Coordinator {
        return Coordinator(onChanged: onChanged, onEnded: onEnded)
    }
    
    func makeUIView(context: UIViewRepresentableContext<DragGestureView>) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        let drag = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.gestureRecognizerPanned))
        drag.delegate = context.coordinator
        view.addGestureRecognizer(drag)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<DragGestureView>) {
        //
    }
    
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        private let onChanged: (DragGestureView.Value) -> Void
        private let onEnded: (DragGestureView.Value) -> Void
        
        private var startLocation = CGPoint.zero
        
        fileprivate init(onChanged: @escaping (DragGestureView.Value) -> Void, onEnded: @escaping (DragGestureView.Value) -> Void) {
            self.onChanged = onChanged
            self.onEnded = onEnded
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
        
        @objc fileprivate func gestureRecognizerPanned(_ gesture: UIPanGestureRecognizer) {
            guard let view = gesture.view else {
                print("Missing view on gesture")
                return
            }
            
            switch gesture.state {
            case .possible, .cancelled, .failed:
                break
            case .began:
                startLocation = gesture.location(in: view)
            case .changed:
                
                let value = DragGestureView.Value(location: gesture.location(in: view), startLocation: startLocation, time: Date(), velocity: gesture.velocity(in: view))
                onChanged(value)
            case .ended:
                let value = DragGestureView.Value(location: gesture.location(in: view), startLocation: startLocation, time: Date(), velocity: gesture.velocity(in: view))
                onEnded(value)
            @unknown default:
                break
            }
        }
    }
}

internal extension View {
    /**
     A dragging motion that invokes an action as the drag-event sequence changes.
     
     - Parameter onChanged: Adds an action to perform when the gesture’s value changes.
     - Parameter onEnded: Adds an action to perform when the gesture ends.
     */
    func dragGesture(onChanged: @escaping (DragGestureView.Value) -> Void, onEnded: @escaping (DragGestureView.Value) -> Void) -> some View {
        self
            .overlay(
                DragGestureView(onChanged: onChanged, onEnded: onEnded)
            )
    }
}

struct DragGestureView_Previews: PreviewProvider {
    static var previews: some View {
        Rectangle()
            .dragGesture(onChanged: { (value) in
                //
            }, onEnded: { (value) in
                //
            })
    }
}
