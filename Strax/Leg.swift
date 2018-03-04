//
// Created by Karl Söderberg on 2018-03-04.
// Copyright (c) 2018 LemonandLime. All rights reserved.
//

import Foundation

struct Leg {
    let name: String
    let type: Type
    let number: String?
    var category: Category
    let direction: String?
    let line: String?
    let distance: String?
    let origin: TravelLocation
    let destination: TravelLocation

    enum CodingKeys: String, CodingKey {
        case name
        case type
        case number
        case category
        case direction = "dir"
        case line
        case distance
        case origin = "Origin"
        case destination = "Destination"
    }

    enum `Type`: String, Codable {
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

    enum Category: String, Codable {
        case bus = "BUS"
        case subway = "MET"
        case train = "TRN"
        case walk
    }
}

extension Leg: Decodable, Encodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(Type.self, forKey: .type)
        number = try container.decodeIfPresent(String.self, forKey: .number)
        category = try container.decodeIfPresent(Category.self, forKey: .category) ?? .walk
        direction = try container.decodeIfPresent(String.self, forKey: .direction)
        line = try container.decodeIfPresent(String.self, forKey: .line)
        distance = try container.decodeIfPresent(String.self, forKey: .distance)
        origin = try container.decode(TravelLocation.self, forKey: .origin)
        destination = try container.decode(TravelLocation.self, forKey: .destination)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(number, forKey: .number)
        try container.encodeIfPresent(category, forKey: .category)
        try container.encodeIfPresent(direction, forKey: .direction)
        try container.encodeIfPresent(line, forKey: .line)
        try container.encodeIfPresent(distance, forKey: .distance)
        try container.encode(origin, forKey: .origin)
        try container.encode(destination, forKey: .destination)
    }
}
