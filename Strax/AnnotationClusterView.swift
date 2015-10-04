//
//  AnnotationClusterView.swift
//  Strax
//
//  Created by Karl Söderberg on 2015-10-04.
//  Copyright © 2015 LemonandLime. All rights reserved.
//

import UIKit

class AnnotationClusterView: MKAnnotationView, AnnotationView {
    
    class func annotationView(locations: [Location])->AnnotationClusterView{
        let view : AnnotationClusterView =  NSBundle.mainBundle().loadNibNamed("AnnotationClusterView", owner: self, options: nil).first as! AnnotationClusterView
        view.locations = locations
        return view
    }

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var pointImage: UIImageView!
    @IBOutlet var clusterButtonsView: UIView!
    var locations: [Location] = []
    var isTravelOrigin = false
    
    func setHighLighted(locations: [Location]) -> Void{
        self.highlighted = true
        makeClusterButtons(locations)
        
    }
    
    override var highlighted: Bool{
        didSet{
            switch highlighted{
            case true:
                makeClusterButtons(locations)
                self.titleLabel.hidden = false
                break
            case false:
                if !isTravelOrigin{
                    titleLabel.hidden = true
                    clusterButtonsView.subviews.forEach{$0.removeFromSuperview()}
                }
                break
            }
        }
    }


    
    
    func makeClusterButtons(locations:[Location]){
        
        guard clusterButtonsView.subviews.count <= 0 else {return}
        
        let clusterButtons = locations.map { (location:Location) -> AnnotationLocationView in
            return AnnotationLocationView.annotationView(location)
        }
        
        let clusterSpread: Double = Double(M_PI / 3.0)
        let distanceToCenter: Double = Double(clusterButtonsView.frame.size.height) / 2.0
        
        let center =  CGPointMake(CGRectGetMidX(clusterButtonsView.bounds), CGRectGetMidY(clusterButtonsView.bounds))
        
        clusterButtons.enumerate().forEach { (index, view) -> () in
            let x = distanceToCenter * sin(clusterSpread * (Double(index) - (Double(clusterButtons.count-1))/2.0));
            let y = -distanceToCenter * cos(clusterSpread * (Double(index) - (Double(clusterButtons.count-1))/2.0));
            clusterButtonsView.addSubview(view)
            view.center = CGPointApplyAffineTransform(center, CGAffineTransformMakeTranslation(CGFloat(x), CGFloat(y)))
            view.highlighted = true
        }
    }

}
