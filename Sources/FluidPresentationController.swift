//    Copyright (c) 2021 Grigor Hakobyan <grighakobian@gmail.com>
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.

#if os(iOS)

import UIKit

open class FluidPresentationController: UIPresentationController {
    
    public let backgroundView: BackgroundView
    public let fluidViewController: FluidViewController
    public let panGestureRecognizer: UIPanGestureRecognizer
    public let tapGestureRecognizer: UITapGestureRecognizer
        
    public init(presentedViewController: FluidViewController, presenting presentingViewController: UIViewController?) {
        self.fluidViewController = presentedViewController
        
        let backgroundStyle = fluidViewController.backgroundStyle
        self.backgroundView = BackgroundView(style: backgroundStyle)
        
        self.panGestureRecognizer = UIPanGestureRecognizer()
        self.tapGestureRecognizer = UITapGestureRecognizer()
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    open override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        guard let containerView = containerView else { return }
        
        /// Configure background view
        containerView.backgroundColor = .clear
        backgroundView.fill(in: containerView)
        
        /// Add a pan gesture recognizer for interactive transition
        panGestureRecognizer.addTarget(self, action: #selector(panned(_:)))
        panGestureRecognizer.cancelsTouchesInView = false
        containerView.addGestureRecognizer(panGestureRecognizer)
        
        /// Add a tap gesture recognizer for top to dismiss
        tapGestureRecognizer.addTarget(self, action: #selector(tapped(_:)))
        containerView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc open func tapped(_ sender: UITapGestureRecognizer) {
        guard fluidViewController.dismissOnBackgroundTap else {
            return
        }
        let location = sender.location(in: containerView)
        if presentedView?.frame.contains(location) == false {
            presentedViewController.dismiss(animated: true)
        }
    }
    
    @objc open func panned(_ recognizer: UIPanGestureRecognizer) {
        guard let containerView = containerView,
              let presentedView = presentedView else {
            return
        }
        
        defer { recognizer.setTranslation(.zero, in: containerView) }
        
        switch recognizer.state {
        case .changed:
            
            let initialTransform = presentedView.transform
            let translation = recognizer.translation(in: containerView)
            var transform = initialTransform.translatedBy(x: 0, y: translation.y)
            
            let safeAreaInsets = presentedView.window?.safeAreaInsets ?? .zero
            let topOffset = fluidViewController.topOffset + safeAreaInsets.top
            transform.ty = max(transform.ty, topOffset)
            presentedView.transform = transform
            
            let containerHeight = containerView.bounds.height
            let preferredContentHeight = fluidViewController.preferredContentSize.height
            var verticalTransform = containerHeight - preferredContentHeight
            if let dragIndicatorStyle = fluidViewController.dragIndicatorStyle {
                if dragIndicatorStyle.topInset.isLess(than: 0.0) {
                    verticalTransform += dragIndicatorStyle.indicatorSize.height
                    verticalTransform += abs(dragIndicatorStyle.topInset)
                }
            }
            let currentOffset = transform.ty
            let progress = verticalTransform / currentOffset
            let alpha = min(max(0.0, progress), 1)
            backgroundView.alpha = alpha
            
        case .ended, .cancelled:
            let springTimingParameters = fluidViewController.springTimingParameters
            let animator = UIViewPropertyAnimator(duration: 0.0, timingParameters: springTimingParameters)
            
            let velocity = recognizer.velocity(in: containerView)
            let shouldDismiss = (velocity.y > 0)
            
            animator.addAnimations {
                presentedView.isUserInteractionEnabled = !shouldDismiss
                if (shouldDismiss == false) {
                    let containerHeight = containerView.bounds.height
                    let preferredContentHeight = self.fluidViewController.preferredContentSize.height
                    var verticalTransform = containerHeight - preferredContentHeight
                    if let dragIndicatorStyle = self.fluidViewController.dragIndicatorStyle {
                        if dragIndicatorStyle.topInset.isLess(than: 0.0) {
                            verticalTransform += dragIndicatorStyle.indicatorSize.height
                            verticalTransform += abs(dragIndicatorStyle.topInset)
                        }
                    }
                    let transform = CGAffineTransform(translationX: 0, y: verticalTransform)
                    presentedView.transform = transform
                }
            }
            
            animator.addCompletion { position in
                if (position == UIViewAnimatingPosition.end) && shouldDismiss {
                    self.fluidViewController.dismiss(animated: true)
                }
            }
            animator.startAnimation()
        default:
            break
        }
    }
}

#endif
