//
//  AddLocationViewController.swift
//  Strax
//
//  Created by Karl Söderberg on 2015-06-16.
//  Copyright (c) 2015 lemonandlime. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var textField: UITextField!
    var annotationViews : [MKAnnotationView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.isUserInteractionEnabled = false
        mapView.delegate = self
    }
    
    func addAnnotation(_ location:Location){
        let point = MKPointAnnotation()
        
        point.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(location.lon), CLLocationDegrees(location.lat))
        mapView.addAnnotation(point)
        mapView.showAnnotations(mapView.annotations, animated: true)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        let pointView = MKAnnotationView(annotation: annotation, reuseIdentifier: "id")
        pointView.image = UIImage(named: "annotation")
        pointView.tintColor = UIColor.gray
        annotationViews.append(pointView)
        return pointView
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]){
        for view in annotationViews{
            view.removeFromSuperview()
            self.textField.superview!.addSubview(view)
        }
    }


    @IBAction func search(_ sender: UITextField) {
        let provider = SLDataProvider.sharedInstance
        
        provider.getLocation(sender.text!) { (result) -> Void in
            switch result{
            case .success(let location):
                let aLocation = DBManager.sharedInstance.newLocation()!
                aLocation.setLocationInfo(location as! [String : Any])
                DBManager.sharedInstance.saveContext()
                self.addAnnotation(aLocation)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
