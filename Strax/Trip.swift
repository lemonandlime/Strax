//
//  Trip.swift
//  Strax
//
//  Created by Karl Söderberg on 2015-07-05.
//  Copyright © 2015 lemonandlime. All rights reserved.
//

import UIKit

struct Trip: Codable {
    var legs: Array<Leg> = Array<Leg>()

    enum CodingKeys: String, CodingKey {
        case legList = "LegList"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let legList = try values.decode(LegList.self, forKey: .legList)
        legs = legList.legs
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(LegList(legs: legs) as LegList, forKey: .legList)
    }
}

extension Trip {
    func departureTime() -> Date? {
        return legs.first?.origin.date
    }
    func arrivalTime() -> Date? {
        return legs.last?.destination.date
    }
}

private struct LegList: Codable {

    enum CodingKeys: String, CodingKey {
        case legs = "Leg"
    }

    let legs: [Leg]

    init(legs: [Leg]) {
        self.legs = legs
    }
}


//{
//    "dur": "50",
//    "chg": "1",
//    "co2": "0.35",
//    "LegList": {
//    "Leg": [{
//    "idx": "0",
//    "name": "buss 194",
//    "type": "BUS",
//    "dir": "Stockholm C",
//    "line": "194",
//    "Origin": {
//    "name": "Bagarmossen",
//    "type": "ST",
//    "id": "400113001",
//    "lon": "18.133391",
//    "lat": "59.276659",
//    "routeIdx": "0",
//    "time": "02:15",
//    "date": "2018-03-02"
//    },
//    "Destination": {
//    "name": "Centralen (Vasagatan)",
//    "type": "ST",
//    "id": "400111518",
//    "lon": "18.057980",
//    "lat": "59.332033",
//    "routeIdx": "20",
//    "time": "02:47",
//    "date": "2018-03-02",
//    "track": "B"
//    },
//    "JourneyDetailRef": {
//    "ref": "ref%3D561102%2F201275%2F953870%2F289902%2F74%3Fdate%3D2018-03-02%26station_evaId%3D400113001%26station_type%3Ddep%26lang%3Dsv%26format%3Djson%26"
//    },
//    "GeometryRef": {
//    "ref": "ref%3D561102%2F201275%2F953870%2F289902%2F74%26startIdx%3D0%26endIdx%3D20%26lang%3Dsv%26format%3Djson%26"
//}
//}
