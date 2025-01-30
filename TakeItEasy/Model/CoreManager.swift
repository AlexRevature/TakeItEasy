//
//  CoreManager.swift
//  TakeItEasy
//
//  Created by Alex Cabrera on 1/13/25.
//

import Foundation
import CoreData

class CoreManager {
    
    private init() {}
    
    static var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "TakeItEasy")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static var managedContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    static func saveContext () {
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
