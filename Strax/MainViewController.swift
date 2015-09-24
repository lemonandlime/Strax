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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        var annotations : [MKPointAnnotation] = []
        for location in locations{
            let point = MKPointAnnotation()
            point.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(location.lon), CLLocationDegrees(location.lat))
            point.title = location.name
            annotations.append(point)
        }
        
        mapView.showAnnotations(annotations, animated: true)
        
    }
    
    func addAnnotation(location:Location){
        let point = MKPointAnnotation()
        
        point.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(location.lon), CLLocationDegrees(location.lat))
        mapView.addAnnotation(point)
        mapView.showAnnotations(mapView.annotations, animated: true)
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        if let currentLocation = locationForName((annotation.title!)!){
            let currentLocationView =  LocationView.locationView(currentLocation)
            
            currentLocationView.didBeginMoveClosure = {(fromPoint, view) in
                self.lineView?.removeFromSuperview()
                self.lineView = LineView(frame: self.view.frame)
                self.view.addSubview(self.lineView!)
                self.view.bringSubviewToFront(view)
                //self.lineView?.updateLine(fromPoint, toPoint: toPoint)
            }
            currentLocationView.didChangeMoveClosure = {(fromPoint, toPoint) in
                self.lineView?.updateLine(fromPoint, toPoint: toPoint)
                self.highlightViewsContainingPoint(toPoint)
            }
            currentLocationView.didEndMoveClosure = {(fromPoint, toPoint) in
                self.lineView?.removeFromSuperview()
                self.lineView = nil
                self.findTravel(fromPoint, toPoint: toPoint, successClosure: { (travel) -> Void in
                    return
                })
            }
            return currentLocationView
        }
        return nil
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
        let subViews = self.view.subviews.filter
            { (T) -> Bool in
                return T is LocationView && CGRectContainsPoint(T.frame, point)
        }
        let name = (subViews.first as? LocationView)?.titleLabel.text
        
        for location in self.locations{
            if location.name == name {
                return location
            }
        }
        return nil
    }
    
    private func locationForName(name:String)->Location?{
        let filteredLocations = locations.filter({ (location) in
            location.name == name
        })
        
        return filteredLocations.first
    }
    
    
    
    @IBAction func search(sender: UITextField) {
        SLDataProvider.sharedInstance.getLocation(sender.text!) { (result) -> Void in
            switch result{
            case .Success(let location):
                let aLocation = DBManager.sharedInstance.newLocation()
                aLocation.setLocationInfo(location as! NSDictionary)
                self.addAnnotation(aLocation)
                
            case .Failure(let error):
                print(error)
            }
        }
        
    }
}

