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


public protocol FluidAnimatedTransitioning: AnyObject {
    /// The offset between the top of the screen safe area and the top of the container view.
    ///
    /// The default value of the property is 20.0.
    var topOffset: CGFloat { get }
    
    /// The preferred size for the view controller’s view.
    var preferredContentSize: CGSize { get set }
    
    /// The style of the container view background.
    ///
    /// The default value of the property is black color with 0.5 opacity.
    var backgroundStyle: BackgroundStyle { get }

    /// Indicates whtere the presented view can be dismissed via background tap.
    ///
    /// The default value of the property is `true`
    var dismissOnBackgroundTap: Bool { get }
    
    /// The corner radius of the presented view
    ///
    /// If set, the presented view top corners should be rounded.
    var cornerRadius: CGFloat? { get }
    
    /// The style of the presented view drag indicator.
    var dragIndicatorStyle: DragIndicatorStyle? { get }
    
    /// The timing information for animations that mimics the behavior of a spring.
    ///
    /// The default value of the property is UISpringTimingParameters(damping: 1.0, response: 0.3)
    var springTimingParameters: UISpringTimingParameters { get }
}


// MARK: - FluidAnimatedTransitioning defaults

public extension FluidAnimatedTransitioning where Self: UIViewController {
    
    var topOffset: CGFloat {
        return 20.0
    }
    
    var backgroundStyle: BackgroundStyle {
        return .solid(color: UIColor(white: 0, alpha: 0.3))
    }
    
    var dismissOnBackgroundTap: Bool {
        return true
    }
    
    var cornerRadius: CGFloat? {
        return nil
    }
    
    var dragIndicatorStyle: DragIndicatorStyle? {
        return nil
    }
    
    var springTimingParameters: UISpringTimingParameters {
        return UISpringTimingParameters(damping: 1.0, response: 0.3)
    }
}

#endif
