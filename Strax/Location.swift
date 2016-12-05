//
//  Location.swift
//  Strax
//
//  Created by Karl Söderberg on 2015-06-15.
//  Copyright (c) 2015 lemonandlime. All rights reserved.
//

import Foundation
import CoreData

@objc (Location)
class Location: NSManagedObject, BaseLocation {
    
    enum key : String {
        case name = "Name"
        case id = "SiteId"
        case type = "Type"
        case lat = "X"
        case lon = "Y"
    }

    @NSManaged var name: String
    @NSManaged var id: String
    @NSManaged var type: String
    @NSManaged var lon: Double
    @NSManaged var lat: Double
    
    func setLocationInfo(_ info:[String: Any]){
        name = info["Name"] as! String
        id = info["SiteId"] as! String
        type = info["Type"] as! String
        
        var xValue = info[key.lat.rawValue] as! String
        xValue.insert(".", at: xValue.characters.index(xValue.startIndex, offsetBy: 2))
        lat = NSString(string:xValue).doubleValue
        
        var yValue = info[key.lon.rawValue] as! String
        yValue.insert(".", at: yValue.characters.index(yValue.startIndex, offsetBy: 2))
        lon = NSString(string:yValue).doubleValue
    }
}
