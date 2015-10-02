//: Playground - noun: a place where people can play

import UIKit
import Darwin

func getView()->UIView{
    let view = UIView(frame: CGRectMake(0, 0, 30, 30))
    view.backgroundColor = UIColor.greenColor()
    return view
}

func makeClusterButton(annotation: UIView){
    
    
    let innerObjects = [getView(),getView(),getView()]
    
    let clusterSpread: Float = Float(M_PI / 5.0)
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
        let y = clusterDistance * sinf(clusterSpread * Float(index));
        let x = clusterDistance * cosf(clusterSpread * Float(index));
        view.frame = CGRectOffset(view.frame, CGFloat(x), CGFloat(y))
        annotation.addSubview(view)
    }
    
}

let view  = UIView(frame: CGRectMake(0, 0, 1000, 1000))
view.backgroundColor = UIColor.whiteColor()

let annotation = UIView(frame: CGRectMake(500, 500, 30, 30))
annotation.backgroundColor = UIColor.redColor()
view.addSubview(annotation)
makeClusterButton(annotation)

view