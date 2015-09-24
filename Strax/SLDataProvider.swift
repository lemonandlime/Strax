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
private let baseUrl = NSURL(string: "http://api.sl.se/api2")!
private let key = "35ea4763c2cc4c47b9aaef634b728943"
private let nameKey = "814ca053c1774eedaf6cfd61e2c7e886"
class SLDataProvider: NSObject {
    
    //private let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager(baseURL: baseUrl)

    
    class var sharedInstance : SLDataProvider {
        return _sharedInstance
    }
    
    override init(){
        //manager.responseSerializer = AFJSONResponseSerializer()
        super.init()
        
    }
    
    func getTrip(from:String, to: String, onCompletion: (Result<Array<Trip>, NSError>) -> Void) {
        let parameters = ["key":key, "originId":from, "destId":to]
        Alamofire.request(.GET, NSURL(string: "http://api.sl.se/api2/TravelplannerV2/trip.JSON")!, parameters: parameters, encoding: .URL, headers: nil).responseData { (response) -> Void in

            
            switch response.result {
            case .Success(let object):
                let json = JSON(data: object)
                var trips = Array<Trip>()
                json["TripList"]["Trip"].forEach({ (_, trip: JSON) -> (Void) in
                    trips.append(Trip(info: trip))
                })
                onCompletion(Result.Success(trips))
                break
                
            case.Failure(let error):
                onCompletion(Result.Failure(error))
                break
            }
        }
    }
    
    func getLocation(name:String, onCompletion: (Result<AnyObject, NSError>) ->Void){
        let parameters = ["key":nameKey, "searchstring":name]
        
        Alamofire.request(.GET, NSURL(string: "http://api.sl.se/api2/typeahead.JSON")!, parameters: parameters, encoding: .URL, headers: nil).responseData { (response) -> Void in
            
            switch response.result{
            case .Success(let object):
                let json = JSON(data: object)
                if json["ResponseData"].array?.count > 0{
                    onCompletion(Result.Success(json["ResponseData"].arrayObject![0]))
                }else{
                    onCompletion(Result.Failure( NSError(domain: "SLData", code: 101, userInfo: nil)))
                }
                
                
            case .Failure(let error):
                onCompletion(Result.Failure(error))
            }
        }
    }
 }
