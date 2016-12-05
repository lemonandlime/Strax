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
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    
    let tripRouteViewModel = TripRouteViewModel()
    
    var trips = Array<Trip>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tripRouteViewModel.createDataSource(trip: trips.first)
        routeTableView.dataSource = tripRouteViewModel
        tableViewHeight.constant = CGFloat(routeTableView.numberOfRows(inSection: 0)) * 44
        
    }
    
    @IBAction func didTapBackground() {
        self.dismiss(animated: true, completion: nil)
    }
}
