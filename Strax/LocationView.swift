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
    
    class func locationView(_ location : Location)->LocationView {
        let view : LocationView =  Bundle.main.loadNibNamed("LocationView", owner: self, options: nil)!.first as! LocationView
        view.titleLabel.text = location.name
        return view
    }
    
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var pointImage : UIImageView!
    let gesturecognizer : UIPanGestureRecognizer = UIPanGestureRecognizer()
    lazy var realCenter : CGPoint = self.pointImage.convert(self.pointImage.center, to: self.superview)
    var startDragPoint : CGPoint = CGPoint(x: 0, y: 0)
    var didBeginMoveClosure:((CGPoint, UIView)->Void)?
    var didChangeMoveClosure:((CGPoint, CGPoint)->Void)?
    var didEndMoveClosure:((CGPoint, CGPoint)->Void)?

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.clipsToBounds = false
        gesturecognizer.addTarget(self, action: #selector(LocationView.didPan(_:)))
        self.addGestureRecognizer(gesturecognizer)
    }
    
    func didPan(_ gestureRecognizer : UIGestureRecognizer){
        let point = gesturecognizer.location(in: superview)
        
        
        switch gesturecognizer.state{
        case .began :
            pointImage!.isHighlighted = true
            
            startDragPoint = gesturecognizer.location(in: superview)
            
            didBeginMoveClosure!(self.center, self)
            return
        case .ended, .cancelled :
            pointImage!.isHighlighted = false
            transform = CGAffineTransform.identity
            didEndMoveClosure!(self.center, point)
            return

            
        case .changed :
            didChangeMoveClosure!(self.center, point)
            return
            
        default:
            return
        }

    }
    


}
