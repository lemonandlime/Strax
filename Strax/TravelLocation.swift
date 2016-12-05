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
    var lon: Double {get}
    var lat: Double {get}
}

struct TravelLocation: BaseLocation {
    let name: String
    let type: String
    let id: String
    let lon: Double
    let lat: Double
    let routeIdx: String?
    let date: Date
    
    
    
    
    init(info: Dictionary<String, String>) {
        
        name    = info["name"]!
        type    = info["type"]!
        id      = info["id"]!
        lon     = NSString(string: info["lon"]!).doubleValue
        lat     = NSString(string: info["lat"]!).doubleValue
        routeIdx = info["routeIdx"]
        date = TravelLocation.dateFrom(info["date"]!, timeString: info["time"]!)
        
    }
    
    fileprivate static func dateFrom(_ dateString: String, timeString: String)->Date!{
        let timeFormatter = DateFormatter()
        let dateFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let timeDate = timeFormatter.date(from: timeString)
        let dateDate = dateFormatter.date(from: dateString)
        let timeInterval = timeDate?.timeIntervalSince1970
        return dateDate!.addingTimeInterval(timeInterval!)
    }
}
