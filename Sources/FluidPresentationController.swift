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


import UIKit

open class FluidPresentationController: UIPresentationController {
    
    public private(set) var panGestureRecognizer = UIPanGestureRecognizer()
    
    open override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        
        if (completed && containerView != nil) {
            // Add pan gesture recognizer for interactive transition
            panGestureRecognizer.addTarget(self, action: #selector(panned))
            panGestureRecognizer.cancelsTouchesInView = false
            containerView?.addGestureRecognizer(panGestureRecognizer)
            // Add tap gesture recognizer for top to dismiss
            let tapGesture = UITapGestureRecognizer()
            tapGesture.addTarget(self, action: #selector(dismiss(_:)))
            tapGesture.cancelsTouchesInView = false
            containerView?.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc open func dismiss(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: containerView)
        
        if presentedView?.frame.contains(location) == false {
            presentedViewController.dismiss(animated: true)
        }
    }
    
    @objc open func panned(recognizer: UIPanGestureRecognizer) {
        guard let containerView = containerView,
              let presentedView = presentedView,
              let fluidViewController = presentedViewController as? FluidViewController else {
            return
        }
        
        defer { recognizer.setTranslation(.zero, in: containerView) }
        
        switch recognizer.state {
        case .changed:
            
            let initialTransform = presentedView.transform
            let translation = recognizer.translation(in: containerView)
            var transform = initialTransform.translatedBy(x: 0, y: translation.y)
            
            let safeAreaInsets = presentedView.safeAreaInsets
            let topOffset = fluidViewController.topOffset + safeAreaInsets.top
            transform.ty = max(transform.ty, topOffset)
            presentedView.transform = transform
            
            let preferredContentHeight = fluidViewController.preferredContentSize.height
            
            let currentOffset = transform.ty
            let progress = preferredContentHeight / currentOffset
            let alpha = min(max(0.0, progress), 1)

            print("alpha: \(alpha)")

            let backgroundColor = fluidViewController.containerViewBackgroundColor
            containerView.backgroundColor = backgroundColor.withAlphaComponent(alpha*0.3)
            
        case .ended, .cancelled:
            
            let velocity = recognizer.velocity(in: containerView)
            let shouldDismiss = (velocity.y > 0)
            let springTimingParameters = UISpringTimingParameters(damping: 1.0, response: 0.3)
            let animator = UIViewPropertyAnimator(duration: 0.0, timingParameters: springTimingParameters)
            
            animator.addAnimations {
                presentedView.isUserInteractionEnabled = !shouldDismiss
                if (shouldDismiss == false) {
                    let translationY = fluidViewController.preferredContentSize.height
                    let transform = CGAffineTransform(translationX: 0, y: translationY)
                    presentedView.transform = transform
                }
            }
            
            animator.addCompletion { position in
                if (position == .end) && shouldDismiss {
                    fluidViewController.dismiss(animated: true)
                }
            }
            animator.startAnimation()
        default:
            break
        }
    }
}
