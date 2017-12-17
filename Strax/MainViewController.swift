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
    var locations: [Location?] = []
    var lineView: LineView?

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locations = DBManager.sharedInstance.allLocations()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let annotations = locations.map { (location) -> Annotation in
            let annotation = Annotation()
            annotation.location = location
            return annotation
        }

        mapView.showAnnotations(annotations, animated: false)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard let location = (annotation as? Annotation)?.location else {
            assertionFailure("Annotation must contain location object")
            return nil
        }
        let view = LocationView.locationView(location)

        view.didBeginMoveClosure = { _, view in
            self.lineView?.removeFromSuperview()
            self.lineView = LineView(frame: self.view.frame)
            self.view.addSubview(self.lineView!)
            self.view.bringSubview(toFront: view)
        }
        view.didChangeMoveClosure = { fromPoint, toPoint in
            self.lineView?.updateLine(fromPoint, toPoint: toPoint)
            self.highlightViewsContainingPoint(toPoint)
        }
        view.didEndMoveClosure = { fromPoint, toPoint in
            self.lineView?.removeFromSuperview()
            self.lineView = nil
            self.findTravel(fromPoint, toPoint: toPoint, successClosure: { _ in
                return
            })
        }

        return view
    }

    fileprivate func highlightViewsContainingPoint(_ point: CGPoint) -> Array<LocationView> {

        let subViews = self.mapView.annotations

        let array: Array<LocationView> = Array()
        for annotation in subViews {
            let object = mapView.view(for: annotation)
            if let locationView = object as? LocationView {
                if locationView.frame.contains(point) {
                    UIView.animate(withDuration: 0.2, animations: { () in
                        locationView.pointImage.isHighlighted = true
                        locationView.transform = CGAffineTransform.identity
                    })

                } else {
                    UIView.animate(withDuration: 0.2, animations: { () in
                        locationView.pointImage.isHighlighted = false
                        locationView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    })
                }
            }
        }
        return array
    }

    fileprivate func findTravel(_ fromPoint: CGPoint, toPoint: CGPoint, successClosure _: (_ travel: Dictionary<String, AnyObject>) -> Void) {
        guard let from = locationForPoint(fromPoint), let to = locationForPoint(toPoint) else { return }

        SLDataProvider.sharedInstance.getTrip(from.id, to: to.id) { result in
            switch result {
            case .success(let trips):
                print(NSString(format: "Found and parsed %d trips", trips.count))
                let alertView = UIAlertController(title: trips.first?.legs.first?.origin.name, message: trips.first?.legs.last?.destination.name, preferredStyle: .alert)

                let action = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    alertView.dismiss(animated: true, completion: nil)
                    return
                })
                alertView.addAction(action)
                self.present(alertView, animated: true, completion: nil)

            case .failure(let error):
                print(error)
            }
        }
    }

    fileprivate func locationForPoint(_ point: CGPoint) -> Location? {
        return (mapView.annotations
            .filter { (mapView.view(for: $0)?.frame)!.contains(point) }
            .first as? Annotation)?
            .location
    }
}
