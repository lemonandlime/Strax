//
//  StraxRealm.swift
//  Strax
//
//  Created by Karl Söderberg on 2017-12-17.
//  Copyright © 2017 LemonandLime. All rights reserved.
//

import Foundation
import RealmSwift

fileprivate var realm: Realm?

extension Realm {
    static func instance() -> Realm {
        guard let foundRealm = realm else {
            var config = Realm.Configuration(
                schemaVersion: 1,
                migrationBlock: nil)
            // JUST DURING DEVELOPMENT MODE
            config.deleteRealmIfMigrationNeeded = true
        
            if !isDevice {
                let fileName = "strax"
                let path = "\(NSHomeDirectory()[..<(NSHomeDirectory().range(of: "/Library/")!.lowerBound)])/Desktop/\(fileName).realm"
                config.fileURL = URL(fileURLWithPath: path)
            }
            try! realm = Realm(configuration: config)
            return try! Realm(configuration: config)
        }
        
        return foundRealm
    }
    
    private static var isDevice: Bool {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            return false
        #else
            return true
        #endif
    }
}
