//
//  UIView+Nib.swift
//  RippleButton
//
//  Created by Chi Hoang on 24/4/20.
//  Copyright © 2020 Hoang Nguyen Chi. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func fromNib<T: UIView>(nibName: String, isInherited: Bool = false) -> T? {
        let bundle = Bundle(for: type(of: self))
        guard let contentView =  bundle.loadNibNamed(nibName,
                                                     owner: self,
                                                     options: nil)?.first as? T else {
                                                        return nil
        }
        contentView.backgroundColor = .clear
        if isInherited {
            self.insertSubview(contentView, at: 0)
        } else {
            self.addSubview(contentView)
        }
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.fixConstraintsInView(self)
        return contentView
    }
    
    func fixConstraintsInView(_ container: UIView!) {
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
