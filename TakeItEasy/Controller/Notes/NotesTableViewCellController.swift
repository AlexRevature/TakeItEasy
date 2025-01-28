//
//  NotesTableViewCellController.swift
//  TakeItEasy
//
//  Created by admin on 1/12/25.
//

import UIKit

class NotesTableViewCellController: UITableViewCell {

    @IBOutlet weak var noteBody: UILabel!
    @IBOutlet weak var noteTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        noteBody.numberOfLines = 3
        noteBody.lineBreakMode = .byWordWrapping
    }
    
    func setCellTheme() {
        noteBody.textColor = .gray
        noteTitle.textColor = ThemeManager.lightTheme.boldText
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
