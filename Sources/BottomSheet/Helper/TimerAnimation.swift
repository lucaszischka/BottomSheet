//
//  TimerAnimation.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021-2022 Lucas Zischka. All rights reserved.
//

import QuartzCore

internal final class TimerAnimation {
    
    typealias Animations = (_ progress: Double, _ time: TimeInterval) -> Void
    typealias Completion = (_ finished: Bool) -> Void
    
    init(duration: TimeInterval, animations: @escaping Animations, completion: Completion? = nil) {
        self.duration = duration
        self.animations = animations
        self.completion = completion
        
        firstFrameTimestamp = CACurrentMediaTime()
        
        let displayLink = CADisplayLink(target: self, selector: #selector(handleFrame))
        displayLink.add(to: .main, forMode: RunLoop.Mode.common)
        self.displayLink = displayLink
    }
    
    deinit {
        invalidate()
    }
    
    func invalidate() {
        guard running else { return }
        running = false
        completion?(false)
        displayLink?.invalidate()
    }
    
    fileprivate let duration: TimeInterval
    fileprivate let animations: Animations
    fileprivate let completion: Completion?
    fileprivate weak var displayLink: CADisplayLink?
    
    fileprivate var running: Bool = true
    
    fileprivate let firstFrameTimestamp: CFTimeInterval
    
    @objc fileprivate func handleFrame(_ displayLink: CADisplayLink) {
        guard running else { return }
        let elapsed = CACurrentMediaTime() - firstFrameTimestamp
        if elapsed >= duration {
            animations(1, duration)
            running = false
            completion?(true)
            displayLink.invalidate()
        } else {
            animations(elapsed / duration, elapsed)
        }
    }
}
