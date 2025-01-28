//
//  NoteEditorViewController.swift
//  TakeItEasy
//
//  Created by admin on 1/13/25.
//

import UIKit

class NoteEditorViewController: UIViewController {

    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var noteBodyTextView: UITextView!
    @IBOutlet weak var noteTitleTextField: UITextField!
    
    // Enough to use selectedNote to check edit mode
    var selectedNote : StoredNote?

    override func viewDidLoad() {
        super.viewDidLoad()
        notificationLabel.text = ""
        setTextFieldContents()
        setViewTheme()
    }
    
    func setViewTheme() {
        view.backgroundColor = ThemeManager.lightTheme.backColor
        noteBodyTextView.layer.borderColor = UIColor.gray.cgColor
        noteBodyTextView.layer.borderWidth = 0.5
        noteBodyTextView.layer.cornerRadius = 2
    }
    
    func setTextFieldContents(){
        if selectedNote != nil {
            noteTitleTextField.text = selectedNote?.name
            noteBodyTextView.text = selectedNote?.text
        }
    }

    // Note: Won't save when closing the app from this screen, may need to be fixed.
    override func viewWillDisappear(_ animated : Bool) {
        let noteName = noteTitleTextField.text
        let noteText = noteBodyTextView.text
        let modifiedDate = Date()

        // Only save note if a title is given
        guard noteName != nil && noteName!.count != 0 else {
            return
        }

        // Proper way to update values
        if selectedNote != nil {
            selectedNote?.name = noteName
            selectedNote?.text = noteText
            selectedNote?.modifiedDate = modifiedDate
        } else {
            let newNote = NoteManager.shared.createNote(name: noteName!, text: noteText!, modifiedDate: modifiedDate)
            NoteManager.shared.addNoteToCurrentUser(noteToAdd: newNote)
        }

        CoreManager.saveContext()

    }
    
    /*@IBAction func saveButtonPressed(_ sender: Any) {
        let newNoteName = noteTitleTextField.text
        let newNoteText = noteBodyTextView.text
        let modifiedDate = Date()
        
        if(newNoteName == "") {
            print("Note name or note text fields are empty")
            notificationLabel.textColor = .red
            notificationLabel.text = "Note title cannot be empty"
            //Does is need to not be empty?
            return
        } else {
            let newNote = NoteManager.shared.createNote(name: newNoteName!, text: newNoteText!, modifiedDate: modifiedDate)
            updateNoteSetWithNote(newNote: newNote)
            navigationController?.popViewController(animated: true)
        }
    }*/
}
