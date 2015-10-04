//
//  Trip.swift
//  Strax
//
//  Created by Karl Söderberg on 2015-07-05.
//  Copyright © 2015 lemonandlime. All rights reserved.
//

import UIKit
import SwiftyJSON

enum TravelType : String{
    
    case UNKNOWN = "UNKNOWN"
    case METRO = "METRO"
    case BUS = "BUS"
    case TRAIN = "TRAIN"
    case TRAM = "TRAM"

    case WALK = "WALK"
    
    func name()->String{
        switch self{
        case .UNKNOWN:  return ""
        case .METRO:    return "Tunnelbana"
        case .BUS:      return "Buss"
        case .TRAIN:    return "Tåg"
        case .TRAM:     return "Spårvagn"
        case .WALK:     return "Promenad"
        }
    }
    
    func verb()->String{
        switch self{
        case .UNKNOWN: return ""
        case .METRO, .BUS, .TRAIN, TRAM: return "åk"
        case .WALK: return "gå"
        }
    }
    
}

protocol BaseLeg{
    var name: String {get}
    var type: TravelType {get}
    var direction: String? {get}
    var line: String? {get}
    var hide: Bool {get}
    var distance: String? {get}
    var origin: TravelLocation {get}
    var destination: TravelLocation {get}
    var JourneyDetailRef: String? {get}
    var GeometryRef: String {get}
}

struct Leg: BaseLeg{
    let name: String
    let type: TravelType
    let direction: String?
    let line: String?
    let hide: Bool
    let distance: String?
    let origin: TravelLocation
    let destination: TravelLocation
    let JourneyDetailRef: String?
    let GeometryRef: String
    
    init(info: Dictionary<String, AnyObject>) {
        print(info)
        name                = info["name"] as! String
        type                = TravelType(rawValue: info["type"] as! String)!
        direction           = info["dir"] as? String
        line                = info["line"] as? String
        hide                = info["hide"] as? String == "true"
        distance            = info["dist"] as? String
        origin              = TravelLocation(info: info["Origin"] as! Dictionary<String, String>)
        destination         = TravelLocation(info: info["Destination"] as! Dictionary<String, String>)
        GeometryRef         = (info["GeometryRef"] as! Dictionary<String, String>)["ref"]!
        
        if let journeyDetail = info["JourneyDetailRef"] as? Dictionary<String, String>{
            JourneyDetailRef = journeyDetail["ref"]
        }else{
            JourneyDetailRef = nil
        }
    }
}

protocol BaseTrip{
    var duration: String {get}
    var numberOfChanges: String {get}
    var legs: Array<BaseLeg> {get}
}

struct Trip: BaseTrip {
    
    let duration: String
    let numberOfChanges: String
    var legs: Array<BaseLeg> = Array<BaseLeg>()

    init(info: JSON) {
        
        switch info["LegList"]["Leg"].type {
        case .Array:
            let legList = info["LegList"]["Leg"]
                for var i = 0; i<legList.count; i+=1{
                    let newLeg = Leg(info: legList[i].dictionaryObject!)
                    legs.append(newLeg)
                }
            
        case .Dictionary:
            legs.append(Leg(info: info["LegList"]["Leg"].dictionaryObject!))
            
        default:
            legs = Array<BaseLeg>()
        }
        
        duration            = info["dur"].stringValue
        numberOfChanges     = info["chg"].stringValue
        
    }
    
}
