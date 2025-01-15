//
//  NoteEditorViewController.swift
//  TakeItEasy
//
//  Created by admin on 1/13/25.
//

import UIKit

class NoteEditorViewController: UIViewController {

    @IBOutlet weak var noteBodyTextView: UITextView!
    @IBOutlet weak var noteTitleTextField: UITextField!
    
    var userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: set text field/view to the provided values or values fetched from core data
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        //TODO: notifiy user if a field is empty
        let newNoteName = noteTitleTextField.text
        let newNoteText = noteBodyTextView.text
        let modifiedDate = Date()
        
        if(newNoteName == nil || newNoteText == nil) {
            print("Note name or note text fields are empty")
            return
        } else {
            let newNote = NoteManager.shared.createNote(name: newNoteName!, text: newNoteText!, modifiedDate: modifiedDate)
            NoteManager.shared.addNoteToCurrentUser(noteToAdd: newNote)
        }
    }
}
