//
//  LineView.swift
//  Umbrella
//
//  Created by Scott Halford on 4/13/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import UIKit

@IBDesignable
class LineView: UIView {

    @IBInspectable var lineWidth: CGFloat = 1.0
    @IBInspectable var lineColor: UIColor? {
        didSet {
            lineCGColor = lineColor?.CGColor
        }
    }
    var lineCGColor: CGColorRef?
    
    override func drawRect(rect: CGRect) {
        // Draw a line from the left to the right at the midpoint of the view's rect height.
        let midpoint = self.bounds.size.height / 2.0
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, lineWidth)
        if let lineCGColor = self.lineCGColor {
            CGContextSetStrokeColorWithColor(context, lineCGColor)
        }
        else {
            CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
        }
        CGContextMoveToPoint(context, 0.0, midpoint)
        CGContextAddLineToPoint(context, self.bounds.size.width, midpoint)
        CGContextStrokePath(context)
    }

}
