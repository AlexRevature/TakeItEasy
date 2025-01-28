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
    //@IBOutlet weak var noteTitleTextField: UITextField!
    
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
            //noteTitleTextField.text = selectedNote?.name
            noteBodyTextView.text = selectedNote?.text
        }
    }
    
    func getNoteTitle() -> String? {
        let noteText = noteBodyTextView.text
        let title = noteText?.components(separatedBy: "\n").first
        return title
    }

    // Note: Won't save when closing the app from this screen, may need to be fixed.
    override func viewWillDisappear(_ animated : Bool) {
        //let noteName = noteTitleTextField.text
        //temp
        let noteName : String? = getNoteTitle()
        //
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
}
