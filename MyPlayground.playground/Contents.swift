//: Playground - noun: a place where people can play

import UIKit
import Darwin

func getView()->UIView{
    let view = UIView(frame: CGRectMake(0, 0, 50, 50))
    view.backgroundColor = UIColor.greenColor()
    return view
}

func makeClusterButton(annotation: UIView){
    
    
    let innerObjects = [getView(),getView(), getView()]
    
    let clusterSpread: Float = Float(M_PI / 3.0)
    let clusterDistance: Float = 100
    
    //
    //  Triangle Values for Buttons' Position
    //
    //      /|      a: triangleA = c * cos(x)
    //   c / | b    b: triangleB = c * sin(x)
    //    /)x|      c: triangleHypotenuse
    //   -----      x: degree
    //     a
    //
    
    innerObjects.enumerate().forEach { (index, view) -> () in
        let x = clusterDistance * sinf(clusterSpread * Float(index));
        let y = -clusterDistance * cosf(clusterSpread * Float(index));
        view.frame = CGRectApplyAffineTransform(view.frame, CGAffineTransformMakeTranslation(CGFloat(x), CGFloat(y)))
        //view.center = CGPointMake(CGFloat(x + 25), CGFloat(y + 25))
        //view.transform = CGAffineTransformMakeRotation(CGFloat(clusterSpread * Float(innerObjects.count / 2)))
        annotation.addSubview(view)
    }
    
    annotation.transform = CGAffineTransformMakeRotation(CGFloat(clusterSpread * Float(innerObjects.count / -2)))
    
}

let view  = UIView(frame: CGRectMake(0, 0, 1000, 1000))
view.backgroundColor = UIColor.whiteColor()

let annotation = UIView(frame: CGRectMake(500, 500, 50, 50))
annotation.backgroundColor = UIColor.redColor()
view.addSubview(annotation)
makeClusterButton(annotation)

view
view