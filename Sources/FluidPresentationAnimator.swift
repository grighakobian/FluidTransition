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

open class FluidPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    public let animator: UIViewPropertyAnimator
    public let springTimingParameters: UISpringTimingParameters
    
    public init(springTimingParameters: UISpringTimingParameters) {
        self.springTimingParameters = springTimingParameters
        self.animator = UIViewPropertyAnimator(duration: 0.0, timingParameters: springTimingParameters)
        super.init()
    }
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animator.duration
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let toViewController = transitionContext.viewController(forKey: .to) as? FluidViewController,
              let presentationController = toViewController.presentationController as? FluidPresentationController,
              let presentationView = transitionContext.view(forKey: .to) else {
            return
        }
        
        fromViewController.beginAppearanceTransition(false, animated: true)
        
        let containerView = transitionContext.containerView
        let initialFrame = transitionContext.initialFrame(for: fromViewController)
        presentationView.transform = CGAffineTransform(translationX: 0, y: initialFrame.height)
 
        containerView.addSubview(presentationView)
        
        if let cornerRadius = toViewController.cornerRadius {
            presentationView.layer.cornerRadius = cornerRadius
            presentationView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        var indicatorView: DragIndicatorView!
        if let indicatorStyle = toViewController.dragIndicatorStyle {
            indicatorView = DragIndicatorView(style: indicatorStyle)
            indicatorView.translatesAutoresizingMaskIntoConstraints = false
            presentationView.addSubview(indicatorView)
            indicatorView.topAnchor.constraint(equalTo: presentationView.topAnchor, constant: indicatorStyle.topInset).isActive = true
            let indicatorSize = indicatorStyle.indicatorSize
            indicatorView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            indicatorView.widthAnchor.constraint(equalToConstant: indicatorSize.width).isActive = true
            indicatorView.heightAnchor.constraint(equalToConstant: indicatorSize.height).isActive = true
        }
        indicatorView?.alpha = 0.0
        presentationController.backgroundView.alpha = 0.0

        let preferredContentHeight = toViewController.preferredContentSize.height
        let verticalTransform = initialFrame.height - preferredContentHeight
        
        animator.addAnimations {
            presentationView.transform = CGAffineTransform(translationX: 0, y: verticalTransform)
            presentationController.backgroundView.alpha = 1.0
            indicatorView?.alpha = 1.0
        }
        
        animator.addCompletion { position in
            if position == UIViewAnimatingPosition.end {
                fromViewController.endAppearanceTransition()
                let didComplete = !transitionContext.transitionWasCancelled
                transitionContext.completeTransition(didComplete)
            }
        }
        
        animator.startAnimation()
    }
}

#endif
