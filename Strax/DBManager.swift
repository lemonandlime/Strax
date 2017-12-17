//
//  DBManager.swift
//  Strax
//
//  Created by Karl Söderberg on 2015-06-15.
//  Copyright (c) 2015 lemonandlime. All rights reserved.
//

import UIKit
import CoreData

private let _DBManagerSharedInstance = DBManager()

class DBManager: NSObject {

    class var sharedInstance: DBManager {
        return _DBManagerSharedInstance
    }

    override init() {
        super.init()
    }

    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1] as URL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "Strax", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("Strax")
        var error: NSError?
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            NSLog("Unresolved error \(error1), \(error1.userInfo)")
            abort()
        } catch {
            fatalError()
        }

        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    func saveContext() {
        if let moc = self.managedObjectContext {
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error as NSError {
                    NSLog("Unresolved error \(error), \(error.userInfo)")
                    abort()
                } catch {
                    abort()
                }
            }
        }
    }

    func newLocation() -> Location! {
        let newLocation: Location = NSEntityDescription.insertNewObject(forEntityName: "Location", into: managedObjectContext!) as! Location
        return newLocation
    }

    func allLocations() -> [Location?] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "Location", in: managedObjectContext!)
        return (try! managedObjectContext!.fetch(fetchRequest)) as! [Location?]
    }
}
