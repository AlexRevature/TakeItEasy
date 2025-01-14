//
//  RegisterController.swift
//  TakeItEasy
//
//  Created by Alex Cabrera on 1/13/25.
//

import UIKit
import CoreData

class RegisterController: UIViewController {
    
    @IBOutlet weak var usernameEntry: UITextField!
    @IBOutlet weak var passwordEntry: UITextField!
    @IBOutlet weak var pwdCheckEntry: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    
    static private func checkEmail(email: String) -> Bool {
        let regex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func registerAction(_ sender: Any) {
        guard let username = usernameEntry.text else {
            statusLabel.text = "Missing Username"
            statusLabel.isHidden = false
            return
        }
        if username.count == 0 {
            statusLabel.text = "Missing Username"
            statusLabel.isHidden = false
            return
        }
        if UserManager.findUser(username: username) != nil {
            statusLabel.text = "Chosen username already in use"
            statusLabel.isHidden = false
            return
        }
        
        guard let password = passwordEntry.text else {
            statusLabel.text = "Missing Password"
            statusLabel.isHidden = false
            return
        }
        if password.count == 0 {
            statusLabel.text = "Missing Password"
            statusLabel.isHidden = false
            return
        }
        
        guard let passwordCheck = pwdCheckEntry.text else {
            statusLabel.text = "Missing Password Verification"
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
        
        let currentUser = UserManager.createUser(username: username)
        UserManager.currentUser = currentUser
        
        // TODO: Add main page transition
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
