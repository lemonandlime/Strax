//
//  ViewController.swift
//  Strax
//
//  Created by Karl Söderberg on 2015-05-30.
//  Copyright (c) 2015 lemonandlime. All rights reserved.
//

import UIKit
import MapKit
import FBAnnotationClustering

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    var locations : [Location!] = []
    var lineView : LineView?
    let clusterManager = FBClusteringManager()
    let locationManager = CLLocationManager()
    var lastTrip = Array<Trip>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        mapView.delegate = self
        locations = DBManager.sharedInstance.allLocations()
        let annotations = locations.map { (location) -> Annotation in
            let annotation = Annotation()
            annotation.location = location
            return annotation
        }
        clusterManager.addAnnotations(annotations)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mapView.showAnnotations(clusterManager.allAnnotations() as! [MKAnnotation], animated: false)
    }
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        if let myLocation = annotation as? MKUserLocation {
            let myLocationView = MKAnnotationView(annotation: myLocation, reuseIdentifier: "myLocation")
            myLocationView.image = UIImage(named: "My Location Point")
            return myLocationView
        }
        
        if let location = (annotation as? Annotation)?.location {
            let view =  AnnotationLocationView.annotationView(location)
            
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
                self.unHighlightAllViews()
                self.findTravel(fromPoint, toPoint: toPoint, successClosure: { (travel) -> Void in
                    return
                })
            }
            
            return view
            
        }else if let cluster = annotation as? FBAnnotationCluster{
            let locations = cluster.annotations.map({ (annotation) -> Location in
                return (annotation as! Annotation).location!
            })
            let view = AnnotationClusterView.annotationView(locations)
            view.titleLabel.text = String(cluster.annotations.count) + " platser"
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        NSOperationQueue().addOperationWithBlock { () -> Void in
            let scale = Double(mapView.bounds.size.width) / mapView.visibleMapRect.size.width
            let annotations = self.clusterManager.clusteredAnnotationsWithinMapRect(mapView.visibleMapRect, withZoomScale: scale)
            self.clusterManager.displayAnnotations(annotations, onMapView: mapView)
        }
    }
    
    
    private func highlightViewsContainingPoint(point:CGPoint)->Array<AnnotationView>{
        let subViews = self.mapView.annotations
        let array : Array<AnnotationView> = Array()
        for annotation in  subViews{
            let object = mapView.viewForAnnotation(annotation)
            if var locationView = object as? AnnotationView{
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    locationView.highlighted = CGRectContainsPoint(locationView.frame, point)
                })
            }
        }
        return array
    }
    
    private func unHighlightAllViews(){
        self.mapView.annotations.forEach {mapView.viewForAnnotation($0)?.highlighted = false}
    }
    
    private func findTravel(fromPoint:CGPoint, toPoint:CGPoint, successClosure:(travel: Dictionary<String, AnyObject>)->Void){
        guard let from = locationForPoint(fromPoint), let to = locationForPoint(toPoint) else {return}
        
        SLDataProvider.sharedInstance.getTrip(from.id, to: to.id) { (result) -> Void in
            switch result {
            case .Success(let trips):
                self.lastTrip = trips
                print(NSString(format: "Found and parsed %d trips", trips.count));
                self.performSegueWithIdentifier("Trip Details", sender: nil)
//                let alertView = UIAlertController(title: trips.first?.legs.first?.origin.name, message: trips.first?.legs.last?.destination.name, preferredStyle: UIAlertControllerStyle.Alert)
//                
//                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
//                    alertView.dismissViewControllerAnimated(true, completion: nil)
//                    return
//                })
//                alertView.addAction(action)
//                self.presentViewController(alertView, animated: true, completion: nil)
                
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "Trip Details":
            (segue.destinationViewController as! TripViewController).trips = lastTrip
            break
        default:
            break
        }
    }
    
    private func locationForPoint(point:CGPoint)->Location?{
        return (mapView.annotations
            .filter{CGRectContainsPoint((mapView.viewForAnnotation($0)?.frame)!, point)}
            .first as? Annotation)?
            .location
    }
}

