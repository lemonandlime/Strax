//
// Created by Karl Söderberg on 2018-03-04.
// Copyright (c) 2018 LemonandLime. All rights reserved.
//

import Foundation

enum TravelType: String, Codable {

    case UNKNOWN
    case METRO
    case BUS
    case TRAIN
    case TRAM
    case WALK

    func name() -> String {
        switch self {
        case .UNKNOWN: return ""
        case .METRO: return "Tunnelbana"
        case .BUS: return "Buss"
        case .TRAIN: return "Tåg"
        case .TRAM: return "Spårvagn"
        case .WALK: return "Promenad"
        }
    }

    func verb() -> String {
        switch self {
        case .UNKNOWN: return ""
        case .METRO, .BUS, .TRAIN, .TRAM: return "åk"
        case .WALK: return "gå"
        }
    }
}