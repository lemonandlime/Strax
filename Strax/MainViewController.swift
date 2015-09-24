//
//  ViewController.swift
//  Strax
//
//  Created by Karl Söderberg on 2015-05-30.
//  Copyright (c) 2015 lemonandlime. All rights reserved.
//

import UIKit
import MapKit

class MainViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    var locations : [Location!] = []
    var lineView : LineView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.userInteractionEnabled = true
        mapView.delegate = self
        locations = DBManager.sharedInstance.allLocations()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let annotations = locations.map { (location) -> Annotation in
            let annotation = Annotation()
            annotation.location = location
            return annotation
        }
        
        mapView.showAnnotations(annotations, animated: false)
    }
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        
        guard let location = (annotation as? Annotation)?.location else{
            assertionFailure("Annotation must contain location object")
            return nil
        }
        let view =  LocationView.locationView(location)
        
        view.didBeginMoveClosure = {(fromPoint, view) in
            self.lineView?.removeFromSuperview()
            self.lineView = LineView(frame: self.view.frame)
            self.view.addSubview(self.lineView!)
            self.view.bringSubviewToFront(view)
        }
        view.didChangeMoveClosure = {(fromPoint, toPoint) in
            self.lineView?.updateLine(fromPoint, toPoint: toPoint)
            self.highlightViewsContainingPoint(toPoint)
        }
        view.didEndMoveClosure = {(fromPoint, toPoint) in
            self.lineView?.removeFromSuperview()
            self.lineView = nil
            self.findTravel(fromPoint, toPoint: toPoint, successClosure: { (travel) -> Void in
                return
            })
        }
        
        return view

    }
    
    
    private func highlightViewsContainingPoint(point:CGPoint)->Array<LocationView>{
        
        let subViews = self.mapView.annotations
        
        let array : Array<LocationView> = Array()
        for annotation in  subViews{
            let object = mapView.viewForAnnotation(annotation)
            if let locationView = object as? LocationView{
                if CGRectContainsPoint(locationView.frame, point){
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        locationView.pointImage.highlighted = true
                        locationView.transform = CGAffineTransformIdentity
                    })
                    
                }else{
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        locationView.pointImage.highlighted = false
                        locationView.transform = CGAffineTransformMakeScale(0.5, 0.5)
                    })
                }
                
            }
            
        }
        return array
    }
    
    private func findTravel(fromPoint:CGPoint, toPoint:CGPoint, successClosure:(travel: Dictionary<String, AnyObject>)->Void){
        let optFromLocation = locationForPoint(fromPoint)
        let optToLocation = locationForPoint(toPoint)
        
        guard let fromLocation = optFromLocation, let toLocation = optToLocation
            where optFromLocation != nil && optToLocation != nil else{
                return
        }
        
        SLDataProvider.sharedInstance.getTrip(fromLocation.id, to: toLocation.id) { (result) -> Void in
            switch result {
            case .Success(let trips):
                print(NSString(format: "Found and parsed %d trips", trips.count));
                let alertView = UIAlertController(title: trips.first?.legs.first?.origin.name, message: trips.first?.legs.last?.destination.name, preferredStyle: UIAlertControllerStyle.Alert)
                
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    alertView.dismissViewControllerAnimated(true, completion: nil)
                    return
                })
                alertView.addAction(action)
                self.presentViewController(alertView, animated: true, completion: nil)
                
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    private func locationForPoint(point:CGPoint)->Location?{
        return (mapView.annotations
            .filter{CGRectContainsPoint((mapView.viewForAnnotation($0)?.frame)!, point)}
            .first as? Annotation)?
            .location
    }
    
    private func locationForName(name:String)->Location?{
        let filteredLocations = locations.filter({ (location) in
            location.name == name
        })
        
        return filteredLocations.first
    }
    
    
    
    //    @IBAction func search(sender: UITextField) {
    //        SLDataProvider.sharedInstance.getLocation(sender.text!) { (result) -> Void in
    //            switch result{
    //            case .Success(let location):
    //                let aLocation = DBManager.sharedInstance.newLocation()
    //                aLocation.setLocationInfo(location as! NSDictionary)
    //                self.addAnnotation(aLocation)
    //
    //            case .Failure(let error):
    //                print(error)
    //            }
    //        }
    //
    //    }
}

