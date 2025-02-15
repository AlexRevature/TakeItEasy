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
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    let errorColor = ThemeManager.customColor(r: 229, g: 162, b: 174)

    static private func checkEmail(email: String) -> Bool {
        let regex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }

    static private func checkNumPassword(password: String) -> Bool {
        let numberMatch = /[0-9]/
        return !(password.matches(of: numberMatch).isEmpty)
    }

    static private func checkSymbolPassword(password: String) -> Bool {
        let symbolMatch = /[^(A-Za-z0-9)]/
        return !(password.matches(of: symbolMatch).isEmpty)
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

        spinner.isHidden = true

    }

    func resetEntry() {
        nameEntry.backgroundColor = .systemGray5
        ageEntry.backgroundColor = .systemGray5
        emailEntry.backgroundColor = .systemGray5
        usernameEntry.backgroundColor = .systemGray5
        passwordEntry.backgroundColor = .systemGray5
        pwdCheckEntry.backgroundColor = .systemGray5

    }

    @IBAction func registerAction(_ sender: Any) {

        resetEntry()

        guard let name = nameEntry.text else {
            statusLabel.text = "Missing name"
            statusLabel.isHidden = false
            nameEntry.backgroundColor = errorColor
            return
        }
        if name.isEmpty {
            statusLabel.text = "Missing name"
            statusLabel.isHidden = false
            nameEntry.backgroundColor = errorColor
            return
        }
        
        guard let ageText = ageEntry.text else {
            statusLabel.text = "Missing age"
            statusLabel.isHidden = false
            ageEntry.backgroundColor = errorColor
            return
        }
        if ageText.isEmpty {
            statusLabel.text = "Missing age"
            statusLabel.isHidden = false
            ageEntry.backgroundColor = errorColor
            return
        }
        guard let age = Int(ageText) else {
            statusLabel.text = "Invalid age entry"
            statusLabel.isHidden = false
            ageEntry.backgroundColor = errorColor
            return
        }
        
        guard let email = emailEntry.text else {
            statusLabel.text = "Missing email"
            statusLabel.isHidden = false
            emailEntry.backgroundColor = errorColor
            return
        }
        if email.isEmpty {
            statusLabel.text = "Missing email"
            statusLabel.isHidden = false
            emailEntry.backgroundColor = errorColor
            return
        }
        if !RegisterController.checkEmail(email: email) {
            statusLabel.text = "Invalid email"
            statusLabel.isHidden = false
            emailEntry.backgroundColor = errorColor
            return
        }
        
        guard let username = usernameEntry.text?.lowercased() else {
            statusLabel.text = "Missing username"
            statusLabel.isHidden = false
            usernameEntry.backgroundColor = errorColor
            return
        }
        if username.isEmpty {
            statusLabel.text = "Missing username"
            statusLabel.isHidden = false
            usernameEntry.backgroundColor = errorColor
            return
        }
        if UserManager.findUser(username: username) != nil {
            statusLabel.text = "Chosen username already in use"
            usernameEntry.backgroundColor = errorColor
            statusLabel.isHidden = false
            return
        }
        
        guard let password = passwordEntry.text else {
            statusLabel.text = "Missing password"
            statusLabel.isHidden = false
            passwordEntry.backgroundColor = errorColor
            return
        }
        if password.isEmpty {
            statusLabel.text = "Missing password"
            statusLabel.isHidden = false
            passwordEntry.backgroundColor = errorColor
            return
        }
        if password.count < 8 {
            statusLabel.text = "Password must be longer than 8 characters"
            statusLabel.isHidden = false
            passwordEntry.backgroundColor = errorColor
            return
        }
        if !RegisterController.checkNumPassword(password: password) {
            statusLabel.text = "Password must have numeric characters"
            statusLabel.isHidden = false
            passwordEntry.backgroundColor = errorColor
            return
        }
        if !RegisterController.checkSymbolPassword(password: password) {
            statusLabel.text = "Password must have non-alphanumeric characters"
            statusLabel.isHidden = false
            passwordEntry.backgroundColor = errorColor
            return
        }

        guard let passwordCheck = pwdCheckEntry.text else {
            statusLabel.text = "Missing password verification"
            statusLabel.isHidden = false
            pwdCheckEntry.backgroundColor = errorColor
            return
        }
        if passwordCheck != password {
            statusLabel.text = "Passwords do not match"
            statusLabel.isHidden = false
            pwdCheckEntry.backgroundColor = errorColor
            return
        }
        
        let credentialStatus = KeychainManager.saveCredentials(username: username, password: password)
        
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

        spinner.isHidden = false
        spinner.startAnimating()

        let currentUser = UserManager.createUser(name: name, age: age, email: email, username: username)
        UserManager.currentUser = currentUser
        UserDefaults.standard.set(username as Any?, forKey: "currentUser")

        ControllerManager.mainTransition(navigationController: self.navigationController)

    }

}
