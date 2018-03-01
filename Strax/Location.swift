//
//  Location.swift
//  Strax
//
//  Created by Karl Söderberg on 2015-06-15.
//  Copyright (c) 2015 lemonandlime. All rights reserved.
//

import Foundation
import RealmSwift
import MapKit

final class Location: RealmObject, BaseLocation {

    enum key: String {
        case name = "Name"
        case id = "SiteId"
        case type = "Type"
        case lat = "X"
        case lon = "Y"
    }

    @objc dynamic var name: String = ""
    @objc dynamic var id: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var lon: Double = 0
    @objc dynamic var lat: Double = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    static func createFromResponse(data: SearchLocationResponseModel) -> Array<Location> {
        var locationList = Array<Location>()
        data.ResponseData?.forEach {
            locationList.append(Location(data: $0))
        }
        return locationList
    }
    
    convenience init(data: LocationResponseModel) {
        self.init()
        name = data.name
        id = data.id
        type = ""
        var xValue = data.lat
        xValue.insert(".", at: xValue.index(xValue.startIndex, offsetBy: 2))
        lon = NSString(string: xValue).doubleValue
        
        var yValue = data.lon
        yValue.insert(".", at: yValue.index(yValue.startIndex, offsetBy: 2))
        lat = NSString(string: yValue).doubleValue
    }
    
//    convenience init(data: SearchLocationResponseModel) {
//        self.init()
//        let locationResponse = data.ResponseData!.first!
//        name = locationResponse.name
//        id = locationResponse.id
//        type = ""
//        var xValue = locationResponse.lat
//        xValue.insert(".", at: xValue.index(xValue.startIndex, offsetBy: 2))
//        lon = NSString(string: xValue).doubleValue
//
//        var yValue = locationResponse.lon
//        yValue.insert(".", at: yValue.index(yValue.startIndex, offsetBy: 2))
//        lat = NSString(string: yValue).doubleValue
//    }
    
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
    
    func coordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    static var allLocations: Results<Location> {
        get {
            return Realm.instance().objects(Location.self)
        }
    }
    
    static func all() -> [Location] {
        return Realm.instance().objects(Location.self).array(type: Location.self)
    }
}
