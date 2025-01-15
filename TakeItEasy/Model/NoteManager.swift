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
    
    func createNote(name: String, text: String, modifiedDate: Date) -> StoredNote{
        let newNote = StoredNote(context: CoreManager.managedContext)
        newNote.text = text
        newNote.name = name
        newNote.modifiedDate = modifiedDate
        
        return newNote
    }
    
    func addNoteToCurrentUser(noteToAdd : StoredNote) {
        UserManager.currentUser?.addToNoteSet(noteToAdd)
        print("Note saved")
    }
    
    func removeNoteFromCurrentUser(note : StoredNote) {
        UserManager.currentUser?.removeFromNoteSet(note)
        print("Note Deleted")
    }
}
