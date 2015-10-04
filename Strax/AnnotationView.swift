//
//  AnnotationLocationView.swift
//  Strax
//
//  Created by Karl Söderberg on 2015-06-27.
//  Copyright (c) 2015 lemonandlime. All rights reserved.
//

import UIKit
import MapKit

protocol AnnotationView{
    var titleLabel: UILabel! {get}
    var pointImage: UIImageView! {get}
    var isTravelOrigin: Bool {get set}
    var frame: CGRect {get set}
    var highlighted: Bool {get set}
}

class AnnotationLocationView: MKAnnotationView, AnnotationView {
    
    class func annotationView(location : Location)->AnnotationLocationView {
        let view : AnnotationLocationView =  NSBundle.mainBundle().loadNibNamed("AnnotationLocationView", owner: self, options: nil).first as! AnnotationLocationView
        view.titleLabel.text = location.name
        return view
    }
    
    class func annotationView()->AnnotationLocationView{
        let view : AnnotationLocationView =  NSBundle.mainBundle().loadNibNamed("AnnotationLocationView", owner: self, options: nil).first as! AnnotationLocationView
        return view
    }
    
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var pointImage : UIImageView!
    let gesturecognizer : UIPanGestureRecognizer = UIPanGestureRecognizer()
    var isTravelOrigin = false
    var didBeginMoveClosure:((CGPoint, UIView)->Void)?
    var didChangeMoveClosure:((CGPoint, CGPoint)->Void)?
    var didEndMoveClosure:((CGPoint, CGPoint)->Void)?

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.clipsToBounds = false
        gesturecognizer.addTarget(self, action: "didPan:")
        self.addGestureRecognizer(gesturecognizer)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.hidden = true
    }
    
    override var highlighted: Bool{
        didSet{
            switch highlighted{
            case true:
                self.titleLabel.hidden = false
                pointImage.transform = CGAffineTransformMakeScale(1.2, 1.2)
                break
            case false:
                if !isTravelOrigin{
                    titleLabel.hidden = true
                    pointImage.transform = CGAffineTransformIdentity
                }
                break
            }
        }
    }
    
    func didPan(gestureRecognizer : UIGestureRecognizer){
        let point = gesturecognizer.locationInView(superview)
        
        
        switch gesturecognizer.state{
        case .Began :
            highlighted = true
            isTravelOrigin = true
            didBeginMoveClosure!(self.center, self)
            return
        case .Ended, .Cancelled :
            highlighted = false
            isTravelOrigin = false
            self.highlighted = false
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
