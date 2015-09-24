//
//  LocationView.swift
//  Strax
//
//  Created by Karl Söderberg on 2015-06-27.
//  Copyright (c) 2015 lemonandlime. All rights reserved.
//

import UIKit
import MapKit

class LocationView: MKAnnotationView {
    
    class func locationView(location : Location)->LocationView {
        let view : LocationView =  NSBundle.mainBundle().loadNibNamed("LocationView", owner: self, options: nil).first as! LocationView
        view.titleLabel.text = location.name
        return view
    }
    
    class func locationView()->LocationView{
        let view : LocationView =  NSBundle.mainBundle().loadNibNamed("LocationView", owner: self, options: nil).first as! LocationView
        return view
    }
    
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var pointImage : UIImageView!
    let gesturecognizer : UIPanGestureRecognizer = UIPanGestureRecognizer()
    lazy var realCenter : CGPoint = self.pointImage.convertPoint(self.pointImage.center, toView: self.superview)
    var startDragPoint : CGPoint = CGPointMake(0, 0)
    var didBeginMoveClosure:((CGPoint, UIView)->Void)?
    var didChangeMoveClosure:((CGPoint, CGPoint)->Void)?
    var didEndMoveClosure:((CGPoint, CGPoint)->Void)?

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.clipsToBounds = false
        gesturecognizer.addTarget(self, action: "didPan:")
        self.addGestureRecognizer(gesturecognizer)
    }
    
    func didPan(gestureRecognizer : UIGestureRecognizer){
        let point = gesturecognizer.locationInView(superview)
        
        
        switch gesturecognizer.state{
        case .Began :
            pointImage!.highlighted = true
            
            startDragPoint = gesturecognizer.locationInView(superview)
            
            didBeginMoveClosure!(self.center, self)
            return
        case .Ended, .Cancelled :
            pointImage!.highlighted = false
            transform = CGAffineTransformIdentity
            didEndMoveClosure!(self.center, point)
            return

            
        case .Changed :
            didChangeMoveClosure!(self.center, point)
            return
            
        default:
            return
        }

    }
    


}
