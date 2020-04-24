//
//  RippleView.swift
//  RippleButton
//
//  Created by Chi Hoang on 24/4/20.
//  Copyright © 2020 Hoang Nguyen Chi. All rights reserved.
//


import UIKit

protocol RippleViewProtocol {
    func touchesBeganRippleView(_ touches: Set<UITouch>, with event: UIEvent?)
    func touchesEndedRippleView(_ touches: Set<UITouch>, with event: UIEvent?)
    func touchesCancelledRippleView(_ touches: Set<UITouch>, with event: UIEvent?)

}

open class RippleView: UIView {
    var delegate: RippleViewProtocol?
    public var rippleLayer: RippleLayer?
    public var rippleFillColor: UIColor?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let rippleLayer = RippleLayer()
        rippleLayer.frame = self.frame
        rippleLayer.fillColor = self.rippleFillColor?.cgColor
        self.layer.addSublayer(rippleLayer)
        let point = touches.first?.location(in: self) ?? .zero
        rippleLayer.touchEffect(point: point)
        self.rippleLayer?.runFadeOutIfComplete = true
        self.rippleLayer = rippleLayer
        delegate?.touchesBeganRippleView(touches, with: event)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.fadeOutRipple()
        delegate?.touchesEndedRippleView(touches, with: event)
    }
    
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let point = touches.first?.location(in: self), !self.point(inside: point,
                                                                      with: event) {
            self.fadeOutRipple()
        }
    }
    
    
    private func fadeOutRipple() {
        guard let rippleLayer = self.rippleLayer else { return }
        if rippleLayer.isAnimating {
            rippleLayer.runFadeOutIfComplete = true
        } else {
            rippleLayer.fadeOutAnimation()
        }
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        delegate?.touchesCancelledRippleView(touches, with: event)
    }
}
