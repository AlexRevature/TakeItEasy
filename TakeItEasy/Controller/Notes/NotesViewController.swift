//
//  NotesTableViewController.swift
//  TakeItEasy
//
//  Created by Joshua Hatch on 1/12/25.
//

import UIKit

class NotesViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource{
    var noteData : [StoredNote] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        //TODO: refresh table whithout needing to restart the app
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        UserManager.currentUser = UserManager.createUser(username: "temp")
        
        setViewTheme()
        
        let coreDataNotes = UserManager.getNoteList()
        if coreDataNotes != nil {
            noteData = UserManager.getNoteList()!
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func setViewTheme() {
        view.backgroundColor = ThemeManager.ligthTheme.backColor
        UIButton.appearance().tintColor = ThemeManager.ligthTheme.primaryColor
        UILabel.appearance().textColor = ThemeManager.ligthTheme.normalText
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
        cell.noteTitle?.text = noteData[indexPath.row].text
        return cell
    }
    
    ///forRowAt
    ///Handle deletion
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            //TODO: HANDLE DELETION ONCE CORE DATA IS SUPPORTED AND AFTER ADDING IS SUPPORTED
        }
    }
    
    ///heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80

    }
    
    ///didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //TODO: Segue to note editor, but have the selected note's data displayed rather than making a new note
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        print("add button pressed")
        self.performSegue(withIdentifier: "toNoteEditor", sender: self)
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
