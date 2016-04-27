//
//  ZipCodeBackground.swift
//  Umbrella
//
//  Created by Scott Halford on 4/20/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedRect: UIView {
    
    //Add a corner radius to a view
    @IBInspectable var cornerRadius: CGFloat = 10.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
}