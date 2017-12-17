//
//  AnnotationClusterView.swift
//  Strax
//
//  Created by Karl Söderberg on 2015-10-04.
//  Copyright © 2015 LemonandLime. All rights reserved.
//

import UIKit
import MapKit

class AnnotationClusterView: MKAnnotationView, AnnotationView {

    class func annotationView(locations: [Location]) -> AnnotationClusterView {
        let view: AnnotationClusterView = Bundle.main.loadNibNamed("AnnotationClusterView", owner: self, options: nil)!.first as! AnnotationClusterView
        view.locations = locations
        return view
    }

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var pointImage: UIImageView!
    @IBOutlet var clusterButtonsView: UIView!
    var locations: [Location] = []
    var isTravelOrigin = false

    func setHighLighted(locations: [Location]) {
        self.isHighlighted = true
        makeClusterButtons(locations: locations)
    }

    override var isHighlighted: Bool {
        didSet {
            switch isHighlighted {
            case true:
                makeClusterButtons(locations: locations)
                self.titleLabel.isHidden = false
                break
            case false:
                if !isTravelOrigin {
                    titleLabel.isHidden = true
                    clusterButtonsView.subviews.forEach { $0.removeFromSuperview() }
                }
                break
            }
        }
    }

    func makeClusterButtons(locations: [Location]) {

        guard clusterButtonsView.subviews.count <= 0 else { return }

        let clusterButtons = locations.map { (location: Location) -> AnnotationLocationView in
            return AnnotationLocationView.annotationView(location: location)
        }

        let clusterSpread: Double = Double(M_PI / 3.0)
        let distanceToCenter: Double = Double(clusterButtonsView.frame.size.height) / 2.0

        let center = CGPoint(x: clusterButtonsView.bounds.midX, y: clusterButtonsView.bounds.midY)

        clusterButtons.enumerated().forEach { index, view in
            let x = distanceToCenter * sin(clusterSpread * (Double(index) - (Double(clusterButtons.count - 1)) / 2.0))
            let y = -distanceToCenter * cos(clusterSpread * (Double(index) - (Double(clusterButtons.count - 1)) / 2.0))
            clusterButtonsView.addSubview(view)
            view.center = center.applying(CGAffineTransform(translationX: CGFloat(x), y: CGFloat(y)))
            view.isHighlighted = true
        }
    }
}
