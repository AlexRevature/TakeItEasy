//
//  NoteManager.swift
//  TakeItEasy
//
//  Created by Joshua Hatch on 1/13/25.
//

import Foundation
import CoreData

class NoteManager {
    
    static var shared = NoteManager()
    
    func createNote(name: String, text: String, modifiedDate: Date) {
        let newNote = StoredNote(context: CoreManager.managedContext)
        newNote.text = text
        newNote.name = name
        newNote.modifiedDate = modifiedDate
        
        do {
            try CoreManager.managedContext.save()
            print("Note data saved")
        } catch let err {
            print("Error creating note: ", err)
        }
       
    }
    
    func findNote(title: String) -> StoredNote? {
        //TODO: all  of this
        return nil
    }
}
