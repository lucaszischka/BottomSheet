//
//  TimerAnimation.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

#if !os(macOS)
import QuartzCore

internal class TimerAnimation {
    
    typealias Animations = (
        _ progress: Double,
        _ time: TimeInterval
    ) -> Void
    
    typealias Completion = (_ finished: Bool) -> Void
    
    init(
        duration: TimeInterval,
        animations: @escaping Animations,
        completion: Completion? = nil
    ) {
        self.duration = duration
        self.animations = animations
        self.completion = completion
        
        self.firstFrameTimestamp = CACurrentMediaTime()
        
        let displayLink = CADisplayLink(
            target: self,
            selector: #selector(
                self.handleFrame
            )
        )
        displayLink.add(
            to: .main,
            forMode: RunLoop.Mode.common
        )
        self.displayLink = displayLink
    }
    
    deinit {
        self.invalidate()
    }
    
    func invalidate() {
        guard self.running else {
            return
        }
        self.running = false
        self.completion?(false)
        self.displayLink?.invalidate()
    }
    
    private let duration: TimeInterval
    private let animations: Animations
    private let completion: Completion?
    private weak var displayLink: CADisplayLink?
    
    private var running: Bool = true
    
    private let firstFrameTimestamp: CFTimeInterval
    
    @objc private func handleFrame(_ displayLink: CADisplayLink) {
        guard self.running else {
            return
        }
        let elapsed = CACurrentMediaTime() - self.firstFrameTimestamp
        if elapsed >= self.duration {
            self.animations(
                1,
                self.duration
            )
            self.running = false
            self.completion?(true)
            displayLink.invalidate()
        } else {
            self.animations(
                elapsed / self.duration, elapsed
            )
        }
    }
}
#endif
