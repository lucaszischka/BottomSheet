//
//  UIScrollViewWrapper.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

#if !os(macOS)
import SwiftUI

internal struct UIScrollViewWrapper<Content: View>: UIViewControllerRepresentable {
    
    @State private var contentOffsetAnimation: TimerAnimation?
    @Binding private var isScrollEnabled: Bool
    @Binding private var dragState: DragGesture.DragState
    private var content: Content
    
    func makeUIViewController(
        context: UIViewControllerRepresentableContext<Self>
    ) -> UIScrollViewViewController<Content> {
        let viewController = UIScrollViewViewController(rootView: self.content)
        viewController.scrollView.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(
        _ viewController: UIScrollViewViewController<Content>,
        context: UIViewControllerRepresentableContext<Self>
    ) {
        // Update the content
        viewController.updateContent(self.content)
        
        // isScrollEnabled
        if viewController.scrollView.isScrollEnabled != self.isScrollEnabled {
            viewController.scrollView.isScrollEnabled = self.isScrollEnabled
        }
        
        // dragState
        switch self.dragState {
        case .none:
            return
        case .changed(value: let value):
            DispatchQueue.main.async {
                self.contentOffsetAnimation?.invalidate()
                self.contentOffsetAnimation = nil
            }
            
            let dims = viewController.scrollView.bounds.size.height
            let clampedY: CGFloat = max(
                min(
                    max(
                        -value.translation.height,
                         0
                    ),
                    viewController.scrollView.contentSize.height - viewController.scrollView.bounds.height
                ),
                0
            )
            let sign: CGFloat = clampedY > -value.translation.height ? -1 : 1
            let result: CGFloat = clampedY + sign * (
                (1.0 - (1.0 / (abs(-value.translation.height - clampedY) * 0.55 / dims + 1.0))) * dims
            )
            
            viewController.scrollView.contentOffset.y = result
        case .ended(value: let value):
            DispatchQueue.main.async {
                self.dragState = .none
            }
            
            let velocityY = (value.location.y - value.predictedEndLocation.y) / (
                UIScrollView.DecelerationRate.normal.rawValue / (
                    1000.0 * (1.0 - UIScrollView.DecelerationRate.normal.rawValue)
                )
            )
            self.completeGesture(
                with: velocityY,
                in: viewController
            )
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(
            contentOffsetAnimation: self.$contentOffsetAnimation,
            isScrollEnabled: self.$isScrollEnabled
        )
    }
    
    private func completeGesture(
        with velocityY: CGFloat,
        in viewController: UIScrollViewViewController<Content>
    ) {
        if !(
            viewController.scrollView.contentOffset.y < 0 ||
            viewController.scrollView.contentOffset.y > max(
                viewController.scrollView.contentSize.height - viewController.scrollView.bounds.height,
                0
            )
        ) {
            self.startDeceleration(
                with: velocityY,
                in: viewController
            )
        } else {
            self.bounce(
                with: velocityY,
                in: viewController
            )
        }
    }
    
    private func startDeceleration(
        with velocityY: CGFloat,
        in viewController: UIScrollViewViewController<Content>
    ) {
        let initialValueY: CGFloat = viewController.scrollView.contentOffset.y
        let decelerationRate: CGFloat = UIScrollView.DecelerationRate.normal.rawValue
        let dCoeff = 1000 * log(decelerationRate)
        let duration: TimeInterval = velocityY == 0 ? 0 : TimeInterval(
            log(-dCoeff * 0.5 / abs(velocityY)) / dCoeff
        ) / 10
        
        DispatchQueue.main.async {
            self.contentOffsetAnimation = TimerAnimation(
                duration: duration,
                animations: { _, time in
                    viewController.scrollView.contentOffset.y = initialValueY + (pow(
                        decelerationRate,
                        CGFloat(1000 * time)
                    ) - 1) / dCoeff * velocityY
                },
                completion: { finished in
                    guard finished else {
                        return
                    }
                    self.bounce(
                        with: velocityY * pow(
                            decelerationRate,
                            CGFloat(1000 * duration)
                        ),
                        in: viewController
                    )
                }
            )
        }
    }
    
    private func bounce(
        with velocityY: CGFloat,
        in viewController: UIScrollViewViewController<Content>
    ) {
        let restOffsetY = max(
            min(
                max(
                    viewController.scrollView.contentOffset.y,
                    0
                ),
                viewController.scrollView.contentSize.height - viewController.scrollView.bounds.height
            ),
            0
        )
        let displacementY = viewController.scrollView.contentOffset.y - restOffsetY
        let threshold = 0.5 / UIScreen.main.scale
        
        let duration: TimeInterval = {
            if abs(displacementY) == 0 && abs(velocityY) == 0 {
                return 0
            }
            
            let timeInterval1 = 1 / 10 * log(2 * abs(displacementY) / threshold)
            let timeInterval2 = 2 / 10 * log(4 * abs(velocityY + 10 * displacementY) / (CGFloat(M_E) * 10 * threshold))
            
            return TimeInterval(
                max(
                    timeInterval1,
                    timeInterval2
                )
            )
        }()
        
        DispatchQueue.main.async {
            self.contentOffsetAnimation = TimerAnimation(
                duration: duration,
                animations: { _, time in
                    viewController.scrollView.contentOffset.y = restOffsetY + (
                        exp(-10 * time) * (displacementY + (velocityY + 10 * displacementY) * time)
                    )
                }
            )
        }
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        
        @Binding fileprivate var contentOffsetAnimation: TimerAnimation?
        @Binding fileprivate var isScrollEnabled: Bool
        
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            DispatchQueue.main.async {
                self.contentOffsetAnimation?.invalidate()
                self.contentOffsetAnimation = nil
            }
        }
        
        func scrollViewDidEndDragging(
            _ scrollView: UIScrollView,
            willDecelerate decelerate: Bool
        ) {
            self.updateScroll(for: scrollView.contentOffset)
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            self.updateScroll(for: scrollView.contentOffset)
        }
        
        private func updateScroll(for offset: CGPoint) {
            DispatchQueue.main.async {
                if offset.y <= 0 {
                    self.isScrollEnabled = false
                } else {
                    self.isScrollEnabled = true
                }
            }
        }
        
        fileprivate init(
            contentOffsetAnimation: Binding<TimerAnimation?>,
            isScrollEnabled: Binding<Bool>
        ) {
            self._contentOffsetAnimation = contentOffsetAnimation
            self._isScrollEnabled = isScrollEnabled
        }
    }
    
    init(
        isScrollEnabled: Binding<Bool>,
        dragState: Binding<DragGesture.DragState>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isScrollEnabled = isScrollEnabled
        self._dragState = dragState
        self.content = content()
    }
}

internal class UIScrollViewViewController<Content: View>: UIViewController {
    
    fileprivate let scrollView: UIScrollView
    fileprivate let hostingController: UIHostingController<Content>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add the UIScrollView
        self.view.addSubview(self.scrollView)
        // Layout the ScrollView
        self.createConstraints()
        self.view.setNeedsUpdateConstraints()
        self.view.updateConstraintsIfNeeded()
        self.view.layoutIfNeeded()
    }
    
    // Update
    fileprivate func updateContent(_ content: Content) {
        self.hostingController.rootView = content
        self.scrollView.addSubview(self.hostingController.view)
        
        var contentSize: CGSize = self.hostingController.view.intrinsicContentSize
        contentSize.width = self.scrollView.frame.width
        self.hostingController.view.frame.size = contentSize
        self.scrollView.contentSize = contentSize
        self.view.updateConstraintsIfNeeded()
        self.view.layoutIfNeeded()
    }
    
    // ScrollView Constraints
    private func createConstraints() {
        NSLayoutConstraint.activate([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    fileprivate init(rootView: Content) {
        // Create the UIScrollView
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = .clear
        self.scrollView = scrollView
        
        // Create the UIHostingController
        let hostingController = UIHostingController(rootView: rootView)
        hostingController.view.backgroundColor = .clear
        self.hostingController = hostingController
        
        super.init(
            nibName: nil,
            bundle: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
