//
//  RippleLayer.swift
//  RippleButton
//
//  Created by Chi Hoang on 24/4/20.
//  Copyright © 2020 Hoang Nguyen Chi. All rights reserved.
//


import Foundation
import UIKit
import CoreGraphics

struct RippleLayerConstant {
    static let fromValueScale: CGFloat = 0.0
    static let toOpacityValue: CGFloat = 1.0
    static let durationOpacity: TimeInterval = 0.075
    static let durationFadeOutDuration: TimeInterval = 0.075
    static let durationRippleTouchDownDuration: TimeInterval = 0.225
    
    private init() {}
}

open class RippleLayer: CAShapeLayer {
    
    public var isAnimating: Bool = false
    public var runFadeOutIfComplete: Bool = false
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override init() {
        super.init()
        self.zPosition = -1
        self.setPath()
    }
    
    func setPath() {
        let radius: CGFloat = sqrt(pow(self.bounds.width, 2.0) + pow( self.bounds.height, 2.0))
        let ovalRect = CGRect(x: self.bounds.midX - radius,
                              y: self.bounds.midY - radius,
                              width: radius * 2,
                              height: radius * 2)
        let path = UIBezierPath.init(ovalIn: ovalRect)
        self.path = path.cgPath
        self.frame = self.bounds
        self.borderWidth = 0
    }
    
    
    @objc func touchEffect(point: CGPoint) {
        self.setPath()
        self.isAnimating = true
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.isAnimating = false
            if self.runFadeOutIfComplete {
                self.fadeOutAnimation()
            }
        }
        
        let positionAnimation: CAKeyframeAnimation = {
            let animation = CAKeyframeAnimation()
            
            let centerPath: UIBezierPath = {
                let path = UIBezierPath()
                let startPoint = point
                let endPoint = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
                path.move(to: startPoint)
                path.addLine(to: endPoint)
                path.close()
                return path
            }()
            
            animation.keyPath = "position"
            animation.path = centerPath.cgPath
            animation.keyTimes = [0, 1]
            animation.values = [0, 1]
            animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0, 0.2, 1)
            return animation
        }()
        
        let scaleAnimation: CABasicAnimation = {
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.fromValue = RippleLayerConstant.fromValueScale
            animation.toValue = 1
            animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0, 0.2, 1)
            return animation
        }()
        
        let colorAnimation: CABasicAnimation = {
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.fromValue = 0
            animation.toValue = RippleLayerConstant.toOpacityValue
            animation.duration = RippleLayerConstant.durationOpacity
            return animation
        }()
        
        
        let group: CAAnimationGroup = {
            let group = CAAnimationGroup()
            group.duration = 0.5
            group.animations = [positionAnimation, scaleAnimation, colorAnimation]
            group.duration = RippleLayerConstant.durationRippleTouchDownDuration
            return group
        }()
        self.add(group, forKey: "all")
        CATransaction.commit()
        
    }
    
    @objc public func fadeInAnimation() {
        self.setPath()
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.fadeOutAnimation()
        }
        let colorAnimation = CABasicAnimation(keyPath: "opacity")
        colorAnimation.fromValue = 0
        colorAnimation.toValue = 1
        colorAnimation.isRemovedOnCompletion = false
        self.add(colorAnimation, forKey: "fadeIn")
        CATransaction.commit()
    }
    
    @objc public func fadeOutAnimation() {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.removeFromSuperlayer()
        }
        let colorAnimation = CABasicAnimation(keyPath: "opacity")
        colorAnimation.fromValue = RippleLayerConstant.toOpacityValue
        colorAnimation.toValue = 0
        colorAnimation.duration = RippleLayerConstant.durationFadeOutDuration
        self.add(colorAnimation, forKey: "fadeout")
        CATransaction.commit()
    }
}
