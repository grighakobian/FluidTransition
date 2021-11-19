//
//  DragIndicatorView.swift
//  FluidTransition
//
//  Created by Grigor Hakobyan on 30.10.21.
//

import UIKit


public struct DragIndicatorStyle {
    public let backgroundStyle: BackgroundStyle
    public let topInset: CGFloat
    public let indicatorSize: CGSize
    public let cornerRadius: CGFloat
    
    public init(backgroundStyle: BackgroundStyle,
                topInset: CGFloat,
                indicatorSize: CGSize,
                cornerRadius: CGFloat) {
        
        self.backgroundStyle = backgroundStyle
        self.topInset = topInset
        self.indicatorSize = indicatorSize
        self.cornerRadius = cornerRadius
    }
}

final class DragIndicatorView: UIView {
    
    let style: DragIndicatorStyle
    
    init(style: DragIndicatorStyle) {
        self.style = style
        super.init(frame: .zero)
        super.backgroundColor = .clear
        
        let indicatorView = view(for: style.backgroundStyle)
        indicatorView.layer.cornerRadius = style.cornerRadius
        indicatorView.clipsToBounds = true
        indicatorView.fill(in: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
