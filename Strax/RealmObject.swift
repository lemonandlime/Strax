//
//  RealmObject.swift
//  Strax
//
//  Created by Karl Söderberg on 2017-12-17.
//  Copyright © 2017 LemonandLime. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class RealmObject: Object {
    public override class func primaryKey() -> String? {
        return nil
    }
    
    public override class func indexedProperties() -> [String] {
        return []
    }
    
    public override class func ignoredProperties() -> [String] {
        return []
    }
    
    required override init(value: Any) {
        super.init(value: value)        
        let mirror = Mirror(reflecting: self)
        for (propName, _) in mirror.children {
            if let propName = propName, let object = self.value(forKeyPath: propName) as? RealmObject {
                let objectCopy = type(of:object).init(value: object)
                self.setValue(objectCopy, forKeyPath: propName)
            }
        }
    }
    
    required init() { super.init() }
    required init(value: Any, schema: RLMSchema) { super.init(value: value, schema: schema)  }
    required init(realm: RLMRealm, schema: RLMObjectSchema) { super.init(realm: realm, schema: schema) }
}
