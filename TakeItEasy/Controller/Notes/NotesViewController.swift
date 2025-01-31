//
//  NotesTableViewController.swift
//  TakeItEasy
//
//  Created by Joshua Hatch on 1/12/25.
//

import UIKit

class NotesViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    var noteData : [StoredNote] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let userDefault = UserDefaults.standard
    
    private var noteToPass : StoredNote? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        setViewThemeManager()
    }
    
    func reloadFromCoreData() {
        let notesFromCoreData = UserManager.getNoteList()
        if  notesFromCoreData != nil {
            noteData = UserManager.getNoteList()!
        }
        sortNotesByRecentcy()
        tableView.reloadData()
    }
    
    func sortNotesByRecentcy() {
        let sortedNotes = noteData.sorted(by: {$0.modifiedDate! > $1.modifiedDate!})
        noteData = sortedNotes
    }
    
    func addAddButtonToNavBar(){
        let plusImage = UIImage(systemName: "plus")
        // Because of the way navBar is set up, the navItem being used is the one from the tabBar here
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: plusImage, style: .done, target: self, action: #selector(self.addButtonPressed))
    }

    func removeAddButtonFromNavBar(){
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
    }

    @objc func addButtonPressed() {
        let storyboard = UIStoryboard(name: "NotesStoryboard", bundle: nil)
        let editorController = storyboard.instantiateViewController(identifier: "NoteEditorController") as! NoteEditorViewController
        editorController.selectedNote = nil
        self.navigationController?.pushViewController(editorController, animated: true)
    }
    
    override func viewWillAppear(_ animated : Bool) {
        super.viewWillAppear(animated)
        addAddButtonToNavBar()
        reloadFromCoreData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeAddButtonFromNavBar()
    }
    
    func setViewThemeManager() {
        searchBar.searchBarStyle = .minimal
    }

    ///numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteData.count
    }
    
    ///cellForRowAt
    ///Initializes the content of a cell and inserts it into the noteTableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NotesTableViewCellController
        cell.noteTitle?.text = noteData[indexPath.row].name
        let noteBodyText = noteData[indexPath.row].text
        if noteBodyText?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            cell.noteBody?.text = "No note text"
        } else {
            cell.noteBody?.text = noteBodyText
        }
        return cell
    }
    
    ///forRowAt
    ///Handles deletion when a row is swiped to the left
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            NoteManager.shared.removeNoteFromCurrentUser(note : noteData[indexPath.row])
            CoreManager.saveContext()
            reloadFromCoreData()
        }
    }
    
    ///heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 103

    }
    
    ///didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let storyboard = UIStoryboard(name: "NotesStoryboard", bundle: nil)
        let editorController = storyboard.instantiateViewController(identifier: "NoteEditorController") as! NoteEditorViewController
        editorController.selectedNote = noteData[indexPath.row]
        // Better to interact with navController when set up progamatically
        self.navigationController?.pushViewController(editorController, animated: true)
    }
    
    func searchNotesByName(resultsArray : inout [StoredNote], searchText: String) {
        for note in noteData {
            let noteName = note.name!.lowercased()
            if noteName.contains(searchText.lowercased()) {
                print("Note found: ",  noteName)
                resultsArray.append(note)
            }
        }
    }
    
    func searchNotesByBody(resultsArray: inout [StoredNote], searchText: String) {
        for note in noteData {
            let noteBody = note.text!.lowercased()
            if noteBody.contains(searchText.lowercased()) /*&& !(resultsArray.contains(note))*/ {
                print("Note found (body):")
                resultsArray.append(note)
            }
        }
    }
    
    ///search bar
    ///searches by note name and then seaches the note body
    ///if the search bar is empty it displays alll notes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //TODO: change name
        var resultsArray : [StoredNote] = []
        
        if (searchText == "") {
            reloadFromCoreData()
            return
        }
        
        print("search text: \"", searchText + "\"")
        
        searchNotesByName(resultsArray: &resultsArray, searchText: searchText)
        searchNotesByBody(resultsArray: &resultsArray, searchText: searchText)
        
        noteData = resultsArray
        tableView.reloadData()
        refreshSearchPool()
    }
    
    func refreshSearchPool() {
        let notesFromCoreData = UserManager.getNoteList()
        if  notesFromCoreData != nil {
            noteData = UserManager.getNoteList()!
        }
        sortNotesByRecentcy()
    }
}
