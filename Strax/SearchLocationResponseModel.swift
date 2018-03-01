//
//  SearchLocationResponseModel.swift
//  Strax
//
//  Created by Karl Söderberg on 2017-12-17.
//  Copyright © 2017 LemonandLime. All rights reserved.
//

import Foundation

struct SearchLocationResponseModel: Codable {
    var StatusCode: Int
    var Message: String?
    var ResponseData: [LocationResponseModel]?
}

struct LocationResponseModel: Codable {
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case id = "SiteId"
        case lat = "X"
        case lon = "Y"
    }
    
    let name: String
    let id: String
    let lat: String
    let lon: String
}

//{
//    "StatusCode": 0,
//    "Message": null,
//    "ExecutionTime": 0,
//    "ResponseData": [{
//    "Name": "Bagarmossen (Stockholm)",
//    "SiteId": "9141",
//    "Type": "Station",
//    "X": "18133508",
//    "Y": "59276596"
//    }, {
//    "Name": "Bagartorp (Solna)",
//    "SiteId": "3441",
//    "Type": "Station",
//    "X": "17997609",
//    "Y": "59377464"
//    }]
//}

