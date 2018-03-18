//
// Created by Karl Söderberg on 2018-03-01.
// Copyright (c) 2018 LemonandLime. All rights reserved.
//

import MapKit
import UIKit
import Foundation

private let defaultInset = UIEdgeInsets(top: 100, left: 40, bottom: 100, right: 40)

extension MKMapView {

    var isZoomedIn: Bool {
        return annotations.count != annotations(in: visibleMapRect).count
    }

    func zoomToAnnotations(_ annotations: [MKAnnotation]? = nil, inset: UIEdgeInsets = defaultInset) {
        let newMapRect = mapRect(for: annotations ?? self.annotations)
        if !MKMapRectIsNull(newMapRect) {
            setVisibleMapRect(newMapRect, edgePadding: inset, animated: true)
        }
    }

    func mapRect(for annotations: [MKAnnotation]) -> MKMapRect {
        // If no annotations
        guard !annotations.isEmpty else {
            return MKMapRectNull
        }
        // If only one annotation
        guard annotations.count > 1 else {
            return MKMapRect(
                    origin: MKMapPointForCoordinate(annotations.first!.coordinate),
                    size: MKMapSize(width: 2000, height: 2000)
            )
        }

        var zoomRect: MKMapRect = MKMapRectNull

        annotations.forEach {
            let rect: MKMapRect = MKMapRect(origin: MKMapPointForCoordinate($0.coordinate), size: MKMapSize(width: 0.1, height: 0.1))
            zoomRect = MKMapRectUnion(zoomRect, rect)
        }

        return zoomRect
    }
}