//
//  ViewController.swift
//  Strax
//
//  Created by Karl Söderberg on 2015-05-30.
//  Copyright (c) 2015 lemonandlime. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    var locations: [Location?] = []
    var lineView: LineView?
//    let clusterManager = FBClusteringManager()
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
//        clusterManager.addAnnotations(annotations)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        mapView.showAnnotations(clusterManager.allAnnotations() as! [MKAnnotation], animated: false)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let myLocation = annotation as? MKUserLocation {
            let myLocationView = MKAnnotationView(annotation: myLocation, reuseIdentifier: "myLocation")
            myLocationView.image = UIImage(named: "My Location Point")
            return myLocationView
        }

        if let location = (annotation as? Annotation)?.location {
            let view = AnnotationLocationView.annotationView(location: location)

            view.didBeginMoveClosure = { _, _ in
                self.lineView?.removeFromSuperview()
                self.lineView = LineView(frame: self.view.frame)
                self.view.addSubview(self.lineView!)
                // self.view.bringSubviewToFront(view)
            }
            view.didChangeMoveClosure = { fromPoint, toPoint in
                self.lineView?.updateLine(fromPoint, toPoint: toPoint)
                _ = self.highlightViewsContainingPoint(point: toPoint)
            }
            view.didEndMoveClosure = { fromPoint, toPoint in
                self.lineView?.removeFromSuperview()
                self.lineView = nil
                self.unHighlightAllViews()
                self.findTravel(fromPoint: fromPoint, toPoint: toPoint, successClosure: { _ in
                    return
                })
            }

            return view

        }
//        else if let cluster = annotation as? FBAnnotationCluster {
//            let locations = cluster.annotations.map({ (annotation) -> Location in
//                return (annotation as! Annotation).location!
//            })
//            let view = AnnotationClusterView.annotationView(locations: locations)
//            view.titleLabel.text = String(cluster.annotations.count) + " platser"
//            return view
//        }
        return nil
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated _: Bool) {
//        OperationQueue().addOperation { () in
//            let scale = Double(mapView.bounds.size.width) / mapView.visibleMapRect.size.width
//            let annotations = self.clusterManager.clusteredAnnotations(within: mapView.visibleMapRect, withZoomScale: scale)
//            self.clusterManager.displayAnnotations(annotations, on: mapView)
//        }
    }

    private func highlightViewsContainingPoint(point: CGPoint) -> Array<AnnotationView> {
        let subViews = self.mapView.annotations
        let array: Array<AnnotationView> = Array()
        for annotation in subViews {
            let object = mapView.view(for: annotation)
            if var locationView = object as? AnnotationView {
                UIView.animate(withDuration: 0.2, animations: { () in
                    locationView.isHighlighted = (locationView.frame).contains(point)
                })
            }
        }
        return array
    }

    private func unHighlightAllViews() {
        self.mapView.annotations.forEach { mapView.view(for: $0)?.isHighlighted = false }
    }

    private func findTravel(fromPoint: CGPoint, toPoint: CGPoint, successClosure _: (_ travel: Dictionary<String, AnyObject>) -> Void) {
        guard let from = locationForPoint(point: fromPoint), let to = locationForPoint(point: toPoint) else { return }

        SLDataProvider.sharedInstance.getTrip(from.id, to: to.id) { result in
            switch result {
            case .success(let trips):
                self.lastTrip = trips
                print(NSString(format: "Found and parsed %d trips", trips.count))
                self.performSegue(withIdentifier: "Trip Details", sender: nil)

            case .failure(let error):
                print(error)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        switch segue.identifier! {
        case "Trip Details":
            (segue.destination as! TripViewController).trips = lastTrip
            break
        default:
            break
        }
    }

    private func locationForPoint(point: CGPoint) -> Location? {
        return (mapView.annotations
            .filter { (mapView.view(for: $0)?.frame)!.contains(point) }
            .filter { $0 is Annotation }
            .first as? Annotation)?
            .location
    }
}
