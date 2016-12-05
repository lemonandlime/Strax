//
//  SLDataProvider.swift
//  Strax
//
//  Created by Karl Söderberg on 2015-05-30.
//  Copyright (c) 2015 lemonandlime. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire




private let _sharedInstance = SLDataProvider()
private let baseUrl = "http://api.sl.se/api2/"
private let key = "35ea4763c2cc4c47b9aaef634b728943"
private let nameKey = "814ca053c1774eedaf6cfd61e2c7e886"
class SLDataProvider: NSObject {
    
    
    class var sharedInstance : SLDataProvider {
        return _sharedInstance
    }
    
    func getTrip(_ from:String, to: String, onCompletion: @escaping (Result<Array<Trip>>) -> Void) {
        let parameters = ["key":key, "originId":from, "destId":to]
        
        let request = Alamofire.request(URL(string: baseUrl+"TravelplannerV2/trip.JSON")!, parameters: parameters)
        
        request.validate().responseData { (response) in
            switch response.result {
            case .success(let object):
                let json = JSON(data: object)
                var trips = Array<Trip>()
                json["TripList"]["Trip"].forEach({ (_, trip: JSON) -> (Void) in
                    trips.append(Trip(info: trip))
                })
                onCompletion(Result.success(trips))
                break
                
            case.failure(let error):
                onCompletion(Result.failure(error))
                break
            }
        }
    }
    
    func getLocation(_ name:String, onCompletion: @escaping (Result<Any>) ->Void){
        let parameters = ["key":nameKey, "searchstring":name]
        
        let request = Alamofire.request(URL(string: baseUrl+"typeahead.JSON")!, parameters: parameters)

        request.validate().responseData { (response) in
            switch response.result{
            case .success(let object):
                let json = JSON(data: object)
                if (json["ResponseData"].array?.count)! > 0{
                    onCompletion(Result.success(json["ResponseData"].arrayObject![0]))
                }else{
                    onCompletion(Result.failure( NSError(domain: "SLData", code: 101, userInfo: nil)))
                }
                
                
            case .failure(let error):
                onCompletion(Result.failure(error))
            }
        }
    }
 }
