//
//  MapInteractor.swift
//  Strax
//
//  Created by Karl Söderberg on 2015-05-30.
//  Copyright (c) 2015 lemonandlime. All rights reserved.
//

import UIKit

class MapInteractor: NSObject {
   
    let provider: NSObject
    
    required init(provider: NSObject) {
        self.provider = provider
        super.init()
    }
    
    func requestTrip(_ from: String, to: String, sucessClosure:(_ trip: NSObject)->Void, errorClosure:(_ error: NSError)->Void){
        
    }
    
}
