//
//  UserController.swift
//  TakeItEasy
//
//  Created by Alex Cabrera on 1/31/25.
//

import UIKit

class UserController: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentUser = UserManager.currentUser

        backView.backgroundColor = ThemeManager.backColor
        backView.layer.borderColor = UIColor.customPrimary.cgColor
        backView.layer.borderWidth = 4
        backView.layer.cornerRadius = 12
        backView.layer.masksToBounds = false
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOpacity = 0.2
        backView.layer.shadowOffset = CGSize(width: 4, height: 4)
        backView.layer.shadowRadius = 3
        backView.layer.shadowPath = UIBezierPath(
            roundedRect: backView.bounds,
            cornerRadius: backView.layer.cornerRadius
        ).cgPath

        usernameLabel.text = currentUser?.username?.capitalized
        nameLabel.text = currentUser?.name
        ageLabel.text = "\(currentUser!.age)"
        emailLabel.text = currentUser?.email
        pointsLabel.text = "Total Points: \(currentUser!.collectedPoints)"
    }

}
