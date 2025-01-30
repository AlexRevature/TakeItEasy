//
//  NoteEditorViewController.swift
//  TakeItEasy
//
//  Created by admin on 1/13/25.
//

import UIKit

class NoteEditorViewController: UIViewController {

    @IBOutlet weak var noteBodyTextView: UITextView!
    
    // Enough to use selectedNote to check edit mode
    var selectedNote : StoredNote?

    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldContents()
        setViewThemeManager()
    }
    
    func setViewThemeManager() {
        noteBodyTextView.layer.borderColor = UIColor.gray.cgColor
        noteBodyTextView.layer.borderWidth = 0.5
        noteBodyTextView.layer.cornerRadius = 2
    }
    
    //this is sloppy but I had to be quick
    func assembleNoteForDisplay() -> String {
        let assembledNote = (selectedNote?.name)! + "\n" + (selectedNote?.text!)!
        return assembledNote
    }
    
    func setTextFieldContents(){
        if selectedNote != nil {
            noteBodyTextView.text = assembleNoteForDisplay()
        }
    }
    
    func getNoteTitle() -> String? {
        let noteText = noteBodyTextView.text
        let title = noteText?.components(separatedBy: "\n").first
        return title
    }
    
    //TODO: Refactor
    func getNoteBody() -> String {
        let fullNote = noteBodyTextView.text
        let segmentedNote = fullNote?.components(separatedBy: "\n")
        
        //TODO: remove the hard codded value
        if segmentedNote?.count == 1 {
            return ""
        }

        var noteBody = ""
        let numberOfLines = segmentedNote?.count
        let lastLineToReadIndex = numberOfLines! - 1
        for i in 1...lastLineToReadIndex {
            noteBody.append(segmentedNote![i])
            noteBody.append("\n")
        }
        return noteBody
    }
    
    func noteIsNotEmpty() -> Bool {
        let noteText = noteBodyTextView.text

        if noteText!.isEmpty{
            return false
        }
        return true
    }
    
    // Note: Won't save when closing the app from this screen, may need to be fixed.
    override func viewWillDisappear(_ animated : Bool) {
        let noteName : String? = getNoteTitle()
        let noteText = getNoteBody()
        let modifiedDate = Date()

        // Only save note if note isn't empty (without a title text field old gaurd statment wasn't as effective)
        guard noteIsNotEmpty() else {
            return
        }

        // Proper way to update values
        if selectedNote != nil {
            selectedNote?.name = noteName
            selectedNote?.text = noteText
            selectedNote?.modifiedDate = modifiedDate
        } else {
            let newNote = NoteManager.shared.createNote(name: noteName!, text: noteText, modifiedDate: modifiedDate)
            NoteManager.shared.addNoteToCurrentUser(noteToAdd: newNote)
        }

        CoreManager.saveContext()

    }
}
