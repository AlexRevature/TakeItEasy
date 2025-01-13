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
    
    ///viewDIdLoad
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: set text field/view to the provided values or values fetched from core data
    }
    
    ///saveButtonPressed
    ///
    @IBAction func saveButtonPressed(_ sender: Any) {
        //TODO: Save to core data
    }
}
