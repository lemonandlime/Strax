//
//  LineView.swift
//  Strax
//
//  Created by Karl Söderberg on 2015-06-27.
//  Copyright (c) 2015 lemonandlime. All rights reserved.
//

import UIKit

class LineView: UIView {

    var fromPoint: CGPoint = CGPointMake(0, 0)
    var toPoint: CGPoint?
    
    override init(frame:CGRect)
    {
        super.init(frame:frame)
        self.backgroundColor = UIColor.clearColor()
        self.clipsToBounds = false
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func updateLine(fromPoint: CGPoint, toPoint: CGPoint){
        self.fromPoint = fromPoint
        self.toPoint = toPoint
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
    drawLineToPoint()
    }
    
    private func drawLineToPoint(){
        if let toPoint = self.toPoint{
            let context = UIGraphicsGetCurrentContext()
            CGContextSaveGState(context)
            CGContextSetLineWidth(context, 2.0)
            CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
            CGContextMoveToPoint(context, fromPoint.x,fromPoint.y);
            CGContextAddLineToPoint(context, toPoint.x,toPoint.y);
            CGContextStrokePath(context);
            CGContextRestoreGState(context);
        }
    }
}
