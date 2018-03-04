//
//  TravelLocation.swift
//  Strax
//
//  Created by Karl Söderberg on 2015-07-05.
//  Copyright © 2015 lemonandlime. All rights reserved.
//

import UIKit

protocol BaseLocation {
    var name: String { get }
    var type: String { get }
    var id: String { get }
    var lon: Double { get }
    var lat: Double { get }
}

struct TravelLocation: BaseLocation {

    enum CodingKeys: String, CodingKey {
        case name
        case type
        case id
        case lon
        case lat
        case date
        case time
    }

    var name: String = "Kalle"
    var type: String = "Kalle"
    let id: String
    let lon: Double
    let lat: Double
    let dateString: String
    let timeString: String

    var date: Date {
        return TravelLocation.dateFrom(dateString, timeString: timeString)
    }

    fileprivate static func dateFrom(_ dateString: String, timeString: String) -> Date! {
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


extension TravelLocation: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encode(id, forKey: .id)
        try container.encode(lon.description, forKey: .lon)
        try container.encode(lat.description, forKey: .lat)
    }
}

extension TravelLocation: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(String.self, forKey: .type)
        id = try container.decode(String.self, forKey: .id)

        let latString = try container.decode(String.self, forKey: .lat)
        let lonString = try container.decode(String.self, forKey: .lon)
        lat = Double(latString)!
        lon = Double(lonString)!

        dateString = try container.decode(String.self, forKey: .date)
        timeString = try container.decode(String.self, forKey: .time)
    }
}


//init(info: Dictionary<String, String>) {
//    name = info["name"]!
//    type = info["type"]!
//    id = info["id"]!
//    lon = NSString(string: info["lon"]!).doubleValue
//    lat = NSString(string: info["lat"]!).doubleValue
//    routeIdx = info["routeIdx"]
//    dateString = info["date"]!
//    timeString = info["time"]!
//    date = TravelLocation.dateFrom(dateString, timeString: timeString)
//}
//
//
//}
