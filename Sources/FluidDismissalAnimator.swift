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

open class FluidDismissalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    public let animator: UIViewPropertyAnimator
    
    public override init() {
        let springTimingParameters = UISpringTimingParameters(damping: 1.0, response: 0.3)
        self.animator = UIViewPropertyAnimator(duration: 0.0, timingParameters: springTimingParameters)
        
        super.init()
    }
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animator.duration
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? FluidViewController,
              let toViewController = transitionContext.viewController(forKey: .to),
              let presentationController = fromViewController.presentationController as? FluidPresentationController,
              let fromView = transitionContext.view(forKey: .from) else {
            return
        }
        
        toViewController.beginAppearanceTransition(true, animated: true)
        
        var verticalTransform = UIScreen.main.bounds.size.height
        if let dragIndicatorStyle = fromViewController.dragIndicatorStyle {
            if dragIndicatorStyle.topInset.isLess(than: 0.0) {
                verticalTransform += dragIndicatorStyle.indicatorSize.height
                verticalTransform += abs(dragIndicatorStyle.topInset)
            }
        }
        
        let transform = CGAffineTransform(translationX: 0, y: verticalTransform)
        let indicatorView = fromViewController.view.subviews.filter({ $0 is DragIndicatorView }).first
        
        animator.addAnimations {
            fromView.transform = transform
            presentationController.backgroundView.alpha = 0.0
            indicatorView?.alpha = 0.0
        }
      
        animator.addCompletion { position in
            if position == UIViewAnimatingPosition.end {
                fromView.removeFromSuperview()
                toViewController.endAppearanceTransition()
                let didComplete = !transitionContext.transitionWasCancelled
                transitionContext.completeTransition(didComplete)
            }
        }
       
        animator.startAnimation()
    }
}

#endif
