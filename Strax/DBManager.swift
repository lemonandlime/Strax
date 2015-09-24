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
    
    class var sharedInstance : DBManager {
        return _DBManagerSharedInstance
    }
    
    override init(){
        super.init()
    }
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("Strax", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Strax")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            //error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict as [NSObject : AnyObject])
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
        var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            if moc.hasChanges{
                do{
                    try moc.save()
                } catch let error as NSError{
                    NSLog("Unresolved error \(error), \(error.userInfo)")
                    abort()
                }catch{
                    abort()
                }
            }
        }
    }
    
    func newLocation()->Location!{
        let newLocation: Location = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: managedObjectContext!) as! Location
        return newLocation
    }

    func allLocations()->[Location!]{
        let fetchRequest : NSFetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Location", inManagedObjectContext: managedObjectContext!)
        return (try! managedObjectContext!.executeFetchRequest(fetchRequest)) as! [Location!]
    }
}
