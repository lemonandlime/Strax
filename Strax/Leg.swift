//
// Created by Karl Söderberg on 2018-03-04.
// Copyright (c) 2018 LemonandLime. All rights reserved.
//

import Foundation

struct Leg: Codable {
    var name: String
    let type: TravelType
    let direction: String?
    let line: String?
    let distance: String?
    let origin: TravelLocation
    let destination: TravelLocation
    let journeyDetailRef: String?
    let geometryRef: String?

    enum CodingKeys: String, CodingKey {
        case name
        case type
        case direction = "dir"
        case line
        case distance
        case origin = "Origin"
        case destination = "Destination"
        case journeyDetailRef = "JourneyDetailRef.ref"
        case geometryRef = "GeometryRef.ref"

    }
//    init(info: Dictionary<String, Any>) {
//        name = info["name"] as! String
//        type = TravelType.swift(rawValue: info["type"] as! String)!
//        direction = info["dir"] as? String
//        line = info["line"] as? String
//        hide = info["hide"] as? String == "true"
//        distance = info["dist"] as? String
//        origin = TravelLocation(info: info["Origin"] as! Dictionary<String, String>)
//        destination = TravelLocation(info: info["Destination"] as! Dictionary<String, String>)
//        GeometryRef = (info["GeometryRef"] as! Dictionary<String, String>)["ref"]!
//
//        if let journeyDetail = info["JourneyDetailRef"] as? Dictionary<String, String> {
//            JourneyDetailRef = journeyDetail["ref"]
//        } else {
//            JourneyDetailRef = nil
//        }
//    }
}