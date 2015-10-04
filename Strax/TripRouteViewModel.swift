//
//  TripRouteViewModel.swift
//  Strax
//
//  Created by Karl Söderberg on 2015-10-04.
//  Copyright © 2015 LemonandLime. All rights reserved.
//

import UIKit

class TripRouteViewModel: NSObject, UITableViewDataSource {
    
    enum CellType {
        case Start(time: String, name: String)
        case Transfer(aTime: String, aName: String, dTime: String, dName: String)
        case Route(name: String)
        case End(time: String, name: String)
        
        func reuseIdentifier() -> String{
            switch self {
            case .Start(time: _, name: _): return "Start"
            case .Transfer(aTime: _, aName: _, dTime: _, dName: _): return "Transfer"
            case .Route(name: _): return "Route"
            case .End(time: _, name: _): return "End"
            }
        }
    }
    
    
    var viewModel = Array<Array<CellType>>()
    
    func createDataSource(trip: Trip?){
        viewModel = []
        guard let trip = trip else {return}
        
        trip.legs.enumerate().forEach{ (index,leg) in
            
            var section = Array<CellType>()
            
            //If this is the first leg make a Start
            if index == 0 {
                section.append(CellType.Start(
                    time: leg.origin.timeString,
                    name: leg.origin.name))
            }
            else {
                let previousLeg = trip.legs[index-1]
                section.append(CellType.Transfer(
                    aTime: previousLeg.destination.timeString,
                    aName: previousLeg.destination.name,
                    dTime: leg.origin.timeString,
                    dName: leg.origin.name))
            }
            
            section.append(CellType.Route(
                name: leg.name))
            
            //If this is the last leg make an End
            if index == trip.legs.count-1 {
                section.append(CellType.End(
                    time: leg.destination.timeString,
                    name: leg.destination.name))
            }
        
        viewModel.append(section)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel[section].count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellData = viewModel[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellData.reuseIdentifier())
        
        switch cellData {
        case .Start(
            time: let time,
            name: let name):
            cell?.textLabel?.text = time + " " + name
        
        case .Transfer(
            aTime: let aTime,
            aName: let aName,
            dTime: let dTime,
            dName: let dName):
            cell?.textLabel?.text = aTime + " " + aName
            cell?.detailTextLabel?.text = dTime + " " + dName
            
        case .Route(
            name: let name):
            cell?.textLabel?.text = name
            
        case .End(
            time: let time,
            name: let name):
            cell?.textLabel?.text = time + " " + name

        }
        

        
        return cell!
    }
    

    
    

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
}
