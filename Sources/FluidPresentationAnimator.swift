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

open class FluidPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    public let presentationAnimator: UIViewPropertyAnimator
    
    public override init() {
        let springTimingParameters = UISpringTimingParameters(damping: 1.0, response: 0.3)
        self.presentationAnimator = UIViewPropertyAnimator(duration: 0.0, timingParameters: springTimingParameters)
        super.init()
    }
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return presentationAnimator.duration
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let toViewController = transitionContext.viewController(forKey: .to) as? FluidViewController,
              let presentationView = transitionContext.view(forKey: .to) else {
            return
        }
        
        fromViewController.beginAppearanceTransition(false, animated: true)
        
        let containerView = transitionContext.containerView
        
        let screenHeight = UIScreen.main.bounds.size.height
        presentationView.transform = CGAffineTransform(translationX: 0, y: screenHeight)
        
        let backgroundColor = toViewController.containerViewBackgroundColor
        
        containerView.addSubview(presentationView)
        containerView.backgroundColor = backgroundColor.withAlphaComponent(0.0)
        
        let preferredContentHeight = toViewController.preferredContentSize.height
        
        presentationAnimator.addAnimations {
            presentationView.transform = CGAffineTransform(translationX: 0, y: preferredContentHeight)
            containerView.backgroundColor = backgroundColor
        }
               
        presentationAnimator.addCompletion { position in
            switch position {
            case .end:
                fromViewController.endAppearanceTransition()
                let didComplete = !transitionContext.transitionWasCancelled
                transitionContext.completeTransition(didComplete)
            default:
                break
            }
        }
        
        presentationAnimator.startAnimation()
    }
}
