//
//  Location.swift
//  Strax
//
//  Created by Karl Söderberg on 2015-06-15.
//  Copyright (c) 2015 lemonandlime. All rights reserved.
//

import Foundation
import RealmSwift

@objc(Location)
class Location: Object, BaseLocation {

    enum key: String {
        case name = "Name"
        case id = "SiteId"
        case type = "Type"
        case lat = "X"
        case lon = "Y"
    }

    var name: String = ""
    var id: String = ""
    var type: String = ""
    var lon: Double = 0
    var lat: Double = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(data: SearchLocationResponseModel) {
        self.init()
        let locationResponse = data.ResponseData.first!
        
        name = locationResponse.Name
        id = locationResponse.SiteId
        type = ""
        var xValue = locationResponse.X
        xValue.insert(".", at: xValue.index(xValue.startIndex, offsetBy: 2))
        lat = NSString(string: xValue).doubleValue
        
        var yValue = locationResponse.Y
        yValue.insert(".", at: yValue.index(yValue.startIndex, offsetBy: 2))
        lon = NSString(string: yValue).doubleValue
    }
    
    func save() {
        let realm = Realm.instance()
        do {
            try realm.write {
                realm.add(self, update: true)
            }
        } catch {
            print(error)
        }
    }
}
