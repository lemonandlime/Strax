//
//  Annotation.swift
//  Strax
//
//  Created by Karl Söderberg on 2015-09-24.
//  Copyright © 2015 LemonandLime. All rights reserved.
//
import MapKit
import UIKit

class Annotation: MKPointAnnotation {

    enum Type {
        case POI
        case Cluster
    }
    
    var location: Location?{
        didSet{
            self.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(location!.lon), CLLocationDegrees(location!.lat))
        }
    }
    var type: Type = .POI
}
