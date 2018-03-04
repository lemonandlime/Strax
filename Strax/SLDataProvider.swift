//
//  SLDataProvider.swift
//  Strax
//
//  Created by Karl Söderberg on 2015-05-30.
//  Copyright (c) 2015 lemonandlime. All rights reserved.
//

import UIKit
import Alamofire

private let _sharedInstance = SLDataProvider()
private let baseUrl = "http://api.sl.se/api2/"
private let key = "35ea4763c2cc4c47b9aaef634b728943"
private let nameKey = "814ca053c1774eedaf6cfd61e2c7e886"
class SLDataProvider: NSObject {

    class var sharedInstance: SLDataProvider {
        return _sharedInstance
    }

    func getTrip(_ from: String, to: String, onCompletion: @escaping (Result<Array<Trip>>) -> Void) {
        let parameters = ["key": key, "originId": from, "destId": to]

        let request = Alamofire.request(URL(string: baseUrl + "TravelplannerV2/trip.JSON")!, parameters: parameters)

        request.validate().responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let responseModel = try JSONDecoder().decode(TripResponseModel.self, from: data)
                    onCompletion(Result.success(responseModel.trips))
                } catch {
                    onCompletion(Result.failure(error))
                }
//                let json = JSON(data: object)
//                var trips = Array<Trip>()
//                json["TripList"]["Trip"].forEach({ (_, trip: JSON) in
//                    trips.append(Trip(info: trip))
//                })
                break

            case .failure(let error):
                onCompletion(Result.failure(error))
                break
            }
        }
    }

    func getLocation(_ name: String, onCompletion: @escaping (Result<SearchLocationResponseModel>) -> Void) {
        let parameters = ["key": nameKey, "searchstring": name]

        let request = Alamofire.request(URL(string: baseUrl + "typeahead.JSON")!, parameters: parameters)
        request.validate().responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let model = try decoder.decode(SearchLocationResponseModel.self, from: data)
                    onCompletion(Result.success(model))
                } catch {
                    onCompletion(Result.failure(error))
                }
                
            case .failure(let error):
                onCompletion(Result.failure(error))
            }
        }
    }
}
