//
//  RealmExtensions.swift
//  Strax
//
//  Created by Karl Söderberg on 2017-12-17.
//  Copyright © 2017 LemonandLime. All rights reserved.
//

import Foundation
import RealmSwift

extension Results {
    func array<T>(type:T.Type) -> [T]{
        var array = Array<T>()
        self.forEach {
            if let object = $0 as? T {
                array.append(object)
            }
        }
        return array
    }
}
