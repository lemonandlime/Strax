//
// Created by Karl Söderberg on 2018-03-04.
// Copyright (c) 2018 LemonandLime. All rights reserved.
//

import Foundation

enum TravelType: String, Codable {

    case publicTransport = "JNY"
    case parkAndRide = "PARK"
    case car = "KISS"
    case bike = "BIKE"
    case transfer = "TRSF"
    case walk = "WALK"
    case taxi = "TAXI"

    func name() -> String {
        switch self {
        case .publicTransport: return "Kollektivtrafik"
        case .car: return "Bil"
        case .bike: return "Cykel"
        case .taxi: return "Taxi"
        case .walk: return "Promenad"
        default: return ""
        }
    }
}