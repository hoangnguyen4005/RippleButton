//
//  RippleButton.swift
//  RippleButton
//
//  Created by Chi Hoang on 24/4/20.
//  Copyright © 2020 Hoang Nguyen Chi. All rights reserved.
//

import UIKit

public class RippleButton: UIButton, RippleViewProtocol {
    public let rippleView = RippleView()
    private var observation: NSKeyValueObservation?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.applyTheme()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyTheme()
    }
    
    public var rippleFillColor: UIColor? = UIColor.white.withAlphaComponent(0.32) {
        willSet(color) {
            self.rippleView.rippleFillColor = color
        }
    }
    
    override public var isEnabled: Bool {
        didSet {
            if isEnabled != oldValue {
                applyTheme()
            }
        }
    }
    override public var isSelected: Bool {
        didSet {
            if isSelected != oldValue {
                applyTheme()
            }
        }
    }
    
    func applyTheme() {
        self.layer.cornerRadius = 4.0
        self.backgroundColor = (isEnabled ? UIColor.red : UIColor.gray)
        self.setTitleColor(.white, for: .normal)
        self.setupRipple()
    }
    
    func setupRipple() {
        rippleView.delegate = self
        self.rippleView.rippleFillColor = self.rippleFillColor
        self.addSubview(self.rippleView)
        self.rippleView.anchor(top: self.topAnchor,
                               leading: self.leadingAnchor,
                               bottom: self.bottomAnchor,
                               trailing: self.trailingAnchor,
                               padding: UIEdgeInsets.zero,
                               size: .zero)
        self.rippleView.clipsToBounds = true
        self.observation = self.observe(
            \.layer.cornerRadius,
            options: [.initial, .old, .new]
        ) { (button, change) in
            guard let newCornerRadius = change.newValue else  { return }
            button.rippleView.layer.cornerRadius = newCornerRadius
        }
    }
    
    func touchesBeganRippleView(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchesBegan(touches, with: event)
        sendActions(for: .touchUpInside)
        
    }
    
    func touchesEndedRippleView(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchesEnded(touches, with: event)
        sendActions(for: .editingDidEnd)
        
    }
    
    func touchesCancelledRippleView(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchesCancelled(touches, with: event)
        sendActions(for: .editingDidEnd)
    }
}


