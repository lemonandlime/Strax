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

    func requestTrip(_: String, to _: String, sucessClosure _: (_ trip: NSObject) -> Void, errorClosure _: (_ error: NSError) -> Void) {
    }
}
