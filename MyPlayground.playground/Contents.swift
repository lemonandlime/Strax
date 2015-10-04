//: Playground - noun: a place where people can play

import UIKit
import Darwin

func getView()->UIView{
    let view = UIView(frame: CGRectMake(0, 0, 50, 50))
    view.backgroundColor = UIColor.greenColor()
    return view
}

func makeClusterButton(annotation: UIView){
    
    let innerObjects = [getView(), getView(), getView(), getView()]
    
    let clusterSpread: Double = Double(M_PI / 4.0)
    let distanceToCenter: Double = Double(annotation.frame.size.height) / 2.0
    
    let center =  CGPointMake(CGRectGetMidX(annotation.bounds), CGRectGetMidY(annotation.bounds))
    
    innerObjects.enumerate().forEach { (index, view) -> () in
        let x = distanceToCenter * sin(clusterSpread * (Double(index) - (Double(innerObjects.count-1))/2.0));
        let y = -distanceToCenter * cos(clusterSpread * (Double(index) - (Double(innerObjects.count-1))/2.0));
        annotation.addSubview(view)
        view.center = CGPointApplyAffineTransform(center, CGAffineTransformMakeTranslation(CGFloat(x), CGFloat(y)))
    }
}

let view  = UIView(frame: CGRectMake(0, 0, 1000, 1000))
view.backgroundColor = UIColor.whiteColor()

let annotation = UIView(frame: CGRectMake(500, 500, 50, 50))
annotation.backgroundColor = UIColor.redColor()
let subViewFrame = UIView(frame: CGRectMake(0, 0, 400, 400))
subViewFrame.center = CGPointMake(CGRectGetMidX(annotation.bounds), CGRectGetMidY(annotation.bounds))
subViewFrame.backgroundColor = UIColor(white: 0.2, alpha: 0.2)
subViewFrame.clipsToBounds = false
annotation.addSubview(subViewFrame)
view.addSubview(annotation)
makeClusterButton(subViewFrame)

view
view
