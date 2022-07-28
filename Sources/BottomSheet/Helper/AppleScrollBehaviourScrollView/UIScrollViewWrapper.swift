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
        // Add/Update the content view
        viewController.hostingController.rootView = self.content
        viewController.scrollView.addSubview(viewController.hostingController.view)
        
//        // MARK: Find someone who knows why this works
//        var contentSize: CGSize = viewController.hostingController.view.intrinsicContentSize
//        contentSize.width = viewController.scrollView.frame.width
//        viewController.hostingController.view.frame.size = contentSize
//        if contentSize.height < viewController.scrollView.frame.height {
//            contentSize.height = viewController.scrollView.frame.height
//            viewController.scrollView.alwaysBounceVertical = true
//        }
//        viewController.scrollView.contentSize = contentSize
//
//        viewController.scrollView.contentInsetAdjustmentBehavior = .never
//
//        NSLayoutConstraint.activate([
//            viewController.hostingController.view.leadingAnchor.constraint(equalTo: viewController.scrollView.leadingAnchor),
//            viewController.hostingController.view.trailingAnchor.constraint(equalTo: viewController.scrollView.trailingAnchor),
//            viewController.hostingController.view.topAnchor.constraint(equalTo: viewController.scrollView.topAnchor)
//        ])
//        let bottomAnchor = viewController.hostingController.view.bottomAnchor.constraint(equalTo: viewController.scrollView.bottomAnchor)
//        bottomAnchor.priority = .defaultLow
//        bottomAnchor.isActive = true
//
//        viewController.view.setNeedsUpdateConstraints()
//        viewController.view.updateConstraintsIfNeeded()
//        viewController.view.layoutIfNeeded()
//        // MARK: -
        
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
            let clampedY: CGFloat = min(
                max(
                    -value.translation.height,
                     0
                ),
                viewController.scrollView.contentSize.height - viewController.scrollView.bounds.height
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
            viewController.scrollView.contentOffset.y > (
                viewController.scrollView.contentSize.height - viewController.scrollView.bounds.height
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
        let duration: TimeInterval = velocityY == 0 ? 0 : TimeInterval(log(-dCoeff * 0.5 / abs(velocityY)) / dCoeff) / 10
        
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
        let restOffsetY = min(
            max(
                viewController.scrollView.contentOffset.y,
                0
            ),
            viewController.scrollView.contentSize.height - viewController.scrollView.bounds.height
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
                    viewController.scrollView.contentOffset.y = restOffsetY + (exp(-10 * time) * (displacementY + (velocityY + 10 * displacementY) * time))
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
    
    fileprivate var scrollView: UIScrollView
    fileprivate let hostingController: UIHostingController<Content>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add the UIScrollView
        self.view.addSubview(self.scrollView)
        
        // Layout the UIScrollView
        NSLayoutConstraint.activate([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.view.setNeedsUpdateConstraints()
        self.view.updateConstraintsIfNeeded()
        self.view.layoutIfNeeded()
    }
    
    fileprivate init(rootView: Content) {
        // Create the UIScrollView
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        self.scrollView = scrollView
        
        // Create the UIHostingController
        let hostingController = UIHostingController(rootView: rootView)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
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
