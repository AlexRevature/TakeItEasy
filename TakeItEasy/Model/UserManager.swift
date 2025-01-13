//
//  UserManager.swift
//  TakeItEasy
//
//  Created by Alex Cabrera on 1/13/25.
//

import CoreData

class UserManager {
    
    private init() {}
    
    static var currentUser: StoredUser?
    
    static func createUser(username: String) -> StoredUser? {
        let storedUser = StoredUser(context: CoreManager.managedContext)
        storedUser.username = username
        
        // Setup default books/quizes/notes/etc
        
        return storedUser
    }
    
    static func findUser(username: String) -> StoredUser? {
        let fetchRequest = StoredUser.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)
        
        do {
            let request = try CoreManager.managedContext.fetch(fetchRequest)
            if let storedUser = request.first {
                return storedUser
            }
        } catch {
            print("Error")
        }
        
        return nil
    }
    
}
