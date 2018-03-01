//
// Created by Karl Söderberg on 2018-03-01.
// Copyright (c) 2018 LemonandLime. All rights reserved.
//

import Foundation
import MapKit.MKAnnotation

class LocationAnnotation: MKPointAnnotation {
    final var id: String

    init(_ location: Location) {
        id = location.id
        super.init()

        coordinate = location.coordinate()
        title = location.name
        subtitle = location.city
    }
}
