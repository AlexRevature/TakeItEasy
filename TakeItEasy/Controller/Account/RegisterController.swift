//
//  RegisterController.swift
//  TakeItEasy
//
//  Created by Alex Cabrera on 1/13/25.
//

import UIKit
import CoreData

class RegisterController: UIViewController {
    
    @IBOutlet weak var nameEntry: UITextField!
    @IBOutlet weak var ageEntry: UITextField!
    @IBOutlet weak var emailEntry: UITextField!
    @IBOutlet weak var usernameEntry: UITextField!
    @IBOutlet weak var passwordEntry: UITextField!
    @IBOutlet weak var pwdCheckEntry: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var backView: UIView!

    @IBOutlet weak var nameBack: UIView!
    @IBOutlet weak var emailBack: UIView!
    @IBOutlet weak var userBack: UIView!
    @IBOutlet weak var passwordBack: UIView!
    @IBOutlet weak var checkBack: UIView!
    

    static private func checkEmail(email: String) -> Bool {
        let regex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        nameBack.backgroundColor = nil
        emailBack.backgroundColor = nil
        userBack.backgroundColor = nil
        passwordBack.backgroundColor = nil
        checkBack.backgroundColor = nil

        nameEntry.backgroundColor = .systemGray5
        ageEntry.backgroundColor = .systemGray5
        emailEntry.backgroundColor = .systemGray5
        usernameEntry.backgroundColor = .systemGray5
        passwordEntry.backgroundColor = .systemGray5
        pwdCheckEntry.backgroundColor = .systemGray5

        backView.backgroundColor = ThemeManager.backColor
        backView.layer.cornerRadius = 12
        backView.layer.masksToBounds = false

    }
    
    @IBAction func registerAction(_ sender: Any) {
        
        guard let name = nameEntry.text else {
            statusLabel.text = "Missing name"
            statusLabel.isHidden = false
            return
        }
        if name.count == 0 {
            statusLabel.text = "Missing name"
            statusLabel.isHidden = false
            return
        }
        
        guard let ageText = ageEntry.text else {
            statusLabel.text = "Missing age"
            statusLabel.isHidden = false
            return
        }
        if ageText.count == 0 {
            statusLabel.text = "Missing age"
            statusLabel.isHidden = false
            return
        }
        guard let age = Int(ageText) else {
            statusLabel.text = "Invalid age entry"
            statusLabel.isHidden = false
            return
        }
        
        guard let email = emailEntry.text else {
            statusLabel.text = "Missing email"
            statusLabel.isHidden = false
            return
        }
        if email.count == 0 {
            statusLabel.text = "Missing email"
            statusLabel.isHidden = false
            return
        }
        if !RegisterController.checkEmail(email: email) {
            statusLabel.text = "Invalid email"
            statusLabel.isHidden = false
            return
        }
        
        guard let username = usernameEntry.text else {
            statusLabel.text = "Missing username"
            statusLabel.isHidden = false
            return
        }
        if username.count == 0 {
            statusLabel.text = "Missing username"
            statusLabel.isHidden = false
            return
        }
        if UserManager.findUser(username: username) != nil {
            statusLabel.text = "Chosen username already in use"
            statusLabel.isHidden = false
            return
        }
        
        guard let password = passwordEntry.text else {
            statusLabel.text = "Missing password"
            statusLabel.isHidden = false
            return
        }
        if password.count == 0 {
            statusLabel.text = "Missing password"
            statusLabel.isHidden = false
            return
        }
        
        guard let passwordCheck = pwdCheckEntry.text else {
            statusLabel.text = "Missing password verification"
            statusLabel.isHidden = false
            return
        }
        if passwordCheck != password {
            statusLabel.text = "Passwords do not match"
            statusLabel.isHidden = false
            return
        }
        
        let credentialStatus = AuthManager.saveCredentials(username: username, password: password)
        
        guard credentialStatus != .collision else {
            statusLabel.text = "Unhandled id collision"
            statusLabel.isHidden = false
            return
        }
        
        guard credentialStatus != .success else {
            statusLabel.text = "Unhandled credentials error"
            statusLabel.isHidden = false
            return
        }
        
        let currentUser = UserManager.createUser(name: name, age: age, email: email, username: username)
        UserManager.currentUser = currentUser
        UserDefaults.standard.set(username as Any?, forKey: "currentUser")

        ControllerManager.mainTransition(navigationController: self.navigationController)

    }

}
