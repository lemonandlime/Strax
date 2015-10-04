//
//  AnnotationClusterView.swift
//  Strax
//
//  Created by Karl Söderberg on 2015-10-04.
//  Copyright © 2015 LemonandLime. All rights reserved.
//

import UIKit

class AnnotationClusterView: MKAnnotationView, AnnotationView {
    
    class func annotationView()->AnnotationClusterView{
        let view : AnnotationClusterView =  NSBundle.mainBundle().loadNibNamed("AnnotationClusterView", owner: self, options: nil).first as! AnnotationClusterView
        return view
    }

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var pointImage: UIImageView!
    @IBOutlet var clusterButtonsView: UIView!
    var isTravelOrigin = false
    
    
    override var highlighted: Bool{
        didSet{
            titleLabel.hidden = !highlighted
            clusterButtonsView.hidden = !highlighted
            
            switch highlighted{
            case true:
                makeClusterButtons()
                break
            case false:
                if !isTravelOrigin{
                    clusterButtonsView.subviews.forEach{$0.removeFromSuperview()}
                }
                break
            }
        }
    }

    
    
    func makeClusterButtons(){
        
        guard clusterButtonsView.subviews.count <= 0 else {return}
        
        let innerObjects = [AnnotationLocationView.annotationView(), AnnotationLocationView.annotationView(), AnnotationLocationView.annotationView(), AnnotationLocationView.annotationView(), AnnotationLocationView.annotationView(), AnnotationLocationView.annotationView()]
        
        let clusterSpread: Double = Double(M_PI / 3.0)
        let distanceToCenter: Double = Double(clusterButtonsView.frame.size.height) / 2.0
        
        let center =  CGPointMake(CGRectGetMidX(clusterButtonsView.bounds), CGRectGetMidY(clusterButtonsView.bounds))
        
        innerObjects.enumerate().forEach { (index, view) -> () in
            let x = distanceToCenter * sin(clusterSpread * (Double(index) - (Double(innerObjects.count-1))/2.0));
            let y = -distanceToCenter * cos(clusterSpread * (Double(index) - (Double(innerObjects.count-1))/2.0));
            clusterButtonsView.addSubview(view)
            view.center = CGPointApplyAffineTransform(center, CGAffineTransformMakeTranslation(CGFloat(x), CGFloat(y)))
            view.highlighted = true
        }
    }

}
