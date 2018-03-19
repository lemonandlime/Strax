//
// Created by Karl Söderberg on 2018-03-18.
// Copyright (c) 2018 LemonandLime. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

extension MKAnnotation {
    func distance(from location: MKAnnotation) -> CLLocationDistance {
        return CLLocation(coordinate: coordinate).distance(from: CLLocation(coordinate: location.coordinate))
    }

    func closestTo(annotations: [MKAnnotation], maxDistance: CLLocationDistance = Double.greatestFiniteMagnitude) -> MKAnnotation? {

        var closestAnnotation: MKAnnotation?
        var closestDistance = Double.greatestFiniteMagnitude
        annotations.forEach { annotation in
            let distance = self.distance(from: annotation)
            if distance < closestDistance {
                closestDistance = distance
                closestAnnotation = annotation
            }
         }

        return closestDistance < maxDistance ? closestAnnotation : nil
    }
}
