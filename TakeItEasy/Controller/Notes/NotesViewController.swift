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
        
        setViewTheme()
        reloadFromCoreData() //may be an unessesaryy call with the call also happening in viewWIllAppear

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func reloadFromCoreData() {
        let notesFromCoreData = UserManager.getNoteList()
        if  notesFromCoreData != nil {
            noteData = UserManager.getNoteList()!
        }
        tableView.reloadData()
    }
    
    func addAddButtonToNavBar(){
        let plusImage = UIImage(systemName: "plus")
        let addButton = UIBarButtonItem(image: plusImage, style: .done, target: self, action: #selector(self.addButtonPressed))
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = addButton
    }
    
    func removeAddButtonFromNavBar(){
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = nil
    }
    
    //TODO: Fix edit mode
    @objc func addButtonPressed() {
        print("nav bar add button pressed")
        userDefault.set(false, forKey: "editMode")
        self.performSegue(withIdentifier: "toNoteEditor", sender: self)
    }
    
    override func viewWillAppear(_ animated : Bool) {
        super.viewWillAppear(animated)
        reloadFromCoreData()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        addAddButtonToNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeAddButtonFromNavBar()
    }
    
    func setViewTheme() {
        view.backgroundColor = ThemeManager.lightTheme.backColor
        tableView.backgroundColor = ThemeManager.lightTheme.backColor
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
        cell.noteBody?.text = noteData[indexPath.row].text
        return cell
    }
    
    ///forRowAt
    ///Handles deletion when a row is swiped to the left
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            NoteManager.shared.removeNoteFromCurrentUser(note : noteData[indexPath.row])
            reloadFromCoreData()
        }
    }
    
    ///heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80

    }
    
    ///This is used to pass the StoredNote object to the NoteEditorViewController if editMode is set to true
    ///editMode is true if a row is selected and it is false if the add button is pressed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let isEditMode = userDefault.bool(forKey: "editMode")
        if segue.identifier == "toNoteEditor" && isEditMode {
            if let destinationVC = segue.destination as? NoteEditorViewController {
                destinationVC.selectedNote = noteToPass
            }
        }
    }
    
    ///didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        userDefault.set(true, forKey: "editMode")
        noteToPass = noteData[indexPath.row]
        self.performSegue(withIdentifier: "toNoteEditor", sender: self)
    }
    
    ///search bar
    ///searches by note name
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var temporaryArray : [StoredNote] = []
        
        if (noteData.isEmpty) {
            return
        }
        
        if (searchText == "") {
            reloadFromCoreData()
            return
        }
        
        //seraches by title
        for note in noteData {
            let noteName = note.name!.lowercased()
            if noteName.contains(searchText.lowercased()) {
                print("Note found")
                temporaryArray.append(note)
            }
        }
        
        //searches by body after the title
        for note in noteData {
            let noteBody = note.text!.lowercased()
            if noteBody.contains(searchText.lowercased()) && !(temporaryArray.contains(note)) {
                print("Note found (body)")
                temporaryArray.append(note)
            }
                
        }
        
        noteData = temporaryArray
        tableView.reloadData()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
