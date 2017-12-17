//
//  LineView.swift
//  Strax
//
//  Created by Karl Söderberg on 2015-06-27.
//  Copyright (c) 2015 lemonandlime. All rights reserved.
//

import UIKit

class LineView: UIView {

    var fromPoint: CGPoint = CGPoint(x: 0, y: 0)
    var toPoint: CGPoint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = false
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    func updateLine(_ fromPoint: CGPoint, toPoint: CGPoint) {
        self.fromPoint = fromPoint
        self.toPoint = toPoint
        setNeedsDisplay()
    }

    override func draw(_: CGRect) {
        drawLineToPoint()
    }

    fileprivate func drawLineToPoint() {
        if let toPoint = self.toPoint {
            let context = UIGraphicsGetCurrentContext()
            context?.saveGState()
            context?.setLineWidth(2.0)
            context?.setStrokeColor(UIColor.black.cgColor)
            context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
            context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
            context?.strokePath()
            context?.restoreGState()
        }
    }
}
