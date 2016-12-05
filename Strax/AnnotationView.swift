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
        let view : AnnotationLocationView =  Bundle.main.loadNibNamed("AnnotationLocationView", owner: self, options: nil)!.first as! AnnotationLocationView
        view.location = location
        view.titleLabel.text = view.location!.name
        return view
    }
    
//    class func annotationView()->AnnotationLocationView{
//        let view : AnnotationLocationView =  NSBundle.mainBundle().loadNibNamed("AnnotationLocationView", owner: self, options: nil).first as! AnnotationLocationView
//        return view
//    }
    
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var pointImage : UIImageView!
    let gesturecognizer : UIPanGestureRecognizer = UIPanGestureRecognizer()
    var isTravelOrigin = false
    var location: Location?
    var didBeginMoveClosure:((CGPoint, UIView)->Void)?
    var didChangeMoveClosure:((CGPoint, CGPoint)->Void)?
    var didEndMoveClosure:((CGPoint, CGPoint)->Void)?

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.clipsToBounds = false
        gesturecognizer.addTarget(self, action: #selector(didPan))
        self.addGestureRecognizer(gesturecognizer)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.isHidden = true
    }
    
    override var isHighlighted: Bool{
        didSet{
            switch isHighlighted{
            case true:
                self.titleLabel.isHidden = false
                pointImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                break
            case false:
                if !isTravelOrigin{
                    titleLabel.isHidden = true
                    pointImage.transform = CGAffineTransform.identity
                }
                break
            }
        }
    }
    
    @objc func didPan(gestureRecognizer : UIGestureRecognizer){
        let point = gesturecognizer.location(in: superview)
        
        
        switch gesturecognizer.state{
        case .began :
            isHighlighted = true
            isTravelOrigin = true
            didBeginMoveClosure!(self.center, self)
            return
        case .ended, .cancelled :
            isHighlighted = false
            isTravelOrigin = false
            self.isHighlighted = false
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
