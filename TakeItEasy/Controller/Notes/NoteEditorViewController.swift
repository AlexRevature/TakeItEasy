//
//  NoteEditorViewController.swift
//  TakeItEasy
//
//  Created by admin on 1/13/25.
//

import UIKit

class NoteEditorViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var noteBodyTextView: UITextView!
    @IBOutlet weak var noteTitleTextField: UITextField!
    
    var userDefault = UserDefaults.standard
    var selectedNote : StoredNote? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationLabel.text = ""
        setTextFieldContents()
        setViewTheme()
    }
    
    func setViewTheme() {
        view.backgroundColor = ThemeManager.lightTheme.backColor
        saveButton.tintColor = ThemeManager.lightTheme.primaryColor
    }
    
    func setTextFieldContents(){
        if selectedNote != nil {
            noteTitleTextField.text = selectedNote?.name
            noteBodyTextView.text = selectedNote?.text
        }
    }
    
    func updateNoteSetWithNote(newNote : StoredNote) {
        let isEditMode = userDefault.bool(forKey: "editMode")
        if isEditMode {
            NoteManager.shared.updateNote(oldNote: selectedNote!, newNote: newNote)
        } else {
            NoteManager.shared.addNoteToCurrentUser(noteToAdd: newNote)
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        //TODO: notifiy user if a field is empty
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
            notificationLabel.textColor = .black
            notificationLabel.text = "Note Saved"
        }
    }
}
