//
//  TripViewController.swift
//  Strax
//
//  Created by Karl Söderberg on 2015-10-04.
//  Copyright © 2015 LemonandLime. All rights reserved.
//

import UIKit

class TripViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var routeTableView: UITableView!
    
    let tripRouteViewModel = TripRouteViewModel()
    
    var trips = Array<Trip>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tripRouteViewModel.createDataSource(trip: trips.first)
        routeTableView.dataSource = tripRouteViewModel
        
    }
}
