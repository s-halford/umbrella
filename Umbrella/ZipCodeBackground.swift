//
//  ZipCodeBackground.swift
//  Umbrella
//
//  Created by Scott Halford on 4/20/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import UIKit

@IBDesignable
class ZipCodeBackground: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 10.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }

}