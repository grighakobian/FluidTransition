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

/// Style of the drag indicator.
public struct DragIndicatorStyle {
    /// The drag indicator size.
    public let indicatorSize: CGSize
    /// The drag indicator top inset.
    public let topInset: CGFloat
    /// The background style of the drag indicator.
    public let backgroundStyle: BackgroundStyle
    
    /// Initializes a new drag indicator style.
    /// - Parameters:
    ///   - indicatorSize: The drag indicator size.
    ///   - topInset: The drag indicator top inset.
    ///   - backgroundStyle: The background style of the drag indicator.
    public init(indicatorSize: CGSize,
                topInset: CGFloat,
                backgroundStyle: BackgroundStyle) {
        
        self.backgroundStyle = backgroundStyle
        self.topInset = topInset
        self.indicatorSize = indicatorSize
    }
}

/// A view that displays a specified drag indicator style.
final class DragIndicatorView: UIView {
    
    /// Initializes a new drag indicator view with a defined indicator style.
    /// - Parameter style: The drag indicator style.
    init(style: DragIndicatorStyle) {
        super.init(frame: .zero)
        
        let backgroundStyle = style.backgroundStyle
        let indicatorView = BackgroundView(style: backgroundStyle)
        indicatorView.fill(in: self)
        self.backgroundColor = .clear
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use init(style:) inseted.")
    }
}

#endif
