//
// Created by Karl Söderberg on 2018-03-18.
// Copyright (c) 2018 LemonandLime. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocation {
    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}