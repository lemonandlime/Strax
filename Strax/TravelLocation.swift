//
//  TravelLocation.swift
//  Strax
//
//  Created by Karl Söderberg on 2015-07-05.
//  Copyright © 2015 lemonandlime. All rights reserved.
//

import UIKit

protocol BaseLocation{
    var name: String {get}
    var type: String {get}
    var id: String {get}
    var lon: NSNumber {get}
    var lat: NSNumber {get}
}

struct TravelLocation: BaseLocation {
    let name: String
    let type: String
    let id: String
    let lon: NSNumber
    let lat: NSNumber
    let routeIdx: String?
    let date: NSDate
    
    
    
    
    init(info: Dictionary<String, String>) {
        
        name    = info["name"]!
        type    = info["type"]!
        id      = info["id"]!
        lon     = NSString(string: info["lon"]!).doubleValue
        lat     = NSString(string: info["lat"]!).doubleValue
        routeIdx = info["routeIdx"]
        date = TravelLocation.dateFrom(info["date"]!, timeString: info["time"]!)
        
    }
    
    private static func dateFrom(dateString: String, timeString: String)->NSDate!{
        let timeFormatter = NSDateFormatter()
        let dateFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let timeDate = timeFormatter.dateFromString(timeString)
        let dateDate = dateFormatter.dateFromString(dateString)
        let timeInterval = timeDate?.timeIntervalSince1970
        return dateDate!.dateByAddingTimeInterval(timeInterval!)
    }
}
