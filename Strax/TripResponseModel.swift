//
// Created by Karl Söderberg on 2018-03-04.
// Copyright (c) 2018 LemonandLime. All rights reserved.
//

import Foundation

struct TripResponseModel: Decodable {
    let trips: [Trip]

    enum CodingKeys: String, CodingKey {
        case TripList
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let tripList = try values.decode(TripsList.self, forKey: .TripList)
        trips = tripList.trips

    }
}

private struct TripsList: Codable {
    let trips: [Trip]
    let noNamespaceSchemaLocation: String?

    enum CodingKeys: String, CodingKey {
        case trips = "Trip"
        case noNamespaceSchemaLocation
    }
}
