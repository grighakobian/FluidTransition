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

/// Style of background.
///
/// - solid: A solid color background.
/// - blur: A blurred background with a defined style.
public enum BackgroundStyle {
    case solid(color: UIColor)
    case blur(style: UIBlurEffect.Style)
}


/// A view that displays a specified background style.
public final class BackgroundView: UIView {
    
    /// Initializes a new background view with a defined background style
    /// - Parameter style: The background style
    init(style: BackgroundStyle) {
        super.init(frame: .zero)
        super.backgroundColor = .clear
        
        let backgroundView = view(for: style)
        backgroundView.fill(in: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init(style:)")
    }
    
    func view(for style: BackgroundStyle) -> UIView {
        switch style {
        case .solid(let color):
            let view = UIView()
            view.backgroundColor = color
            return view
        case .blur(let style):
            let effect = UIBlurEffect(style: style)
            return UIVisualEffectView(effect: effect)
        }
    }
}

#endif
