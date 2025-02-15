//
//  LoginController.swift
//  TakeItEasy
//
//  Created by Alex Cabrera on 1/13/25.
//

import UIKit

class LoginController: UIViewController {
    
    @IBOutlet weak var usernameEntry: UITextField!
    @IBOutlet weak var passwordEntry: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var persistenceToggle: UISwitch!
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var userBack: UIView!
    @IBOutlet weak var passwordBack: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    let errorColor = ThemeManager.customColor(r: 229, g: 162, b: 174)

    override func viewDidLoad() {
        super.viewDidLoad()

        userBack.backgroundColor = nil
        passwordBack.backgroundColor = nil

        usernameEntry.backgroundColor = .systemGray5
        passwordEntry.backgroundColor = .systemGray5

        backView.backgroundColor = ThemeManager.backColor
        backView.layer.cornerRadius = 12
        backView.layer.masksToBounds = false

        spinner.isHidden = true

    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        guard let username = usernameEntry.text?.lowercased() else {
            statusLabel.text = "Missing Username"
            statusLabel.isHidden = false
            usernameEntry.backgroundColor = errorColor
            return
        }
        if username.count == 0 {
            statusLabel.text = "Missing Username"
            statusLabel.isHidden = false
            usernameEntry.backgroundColor = errorColor
            return
        }

        guard let password = passwordEntry.text else {
            statusLabel.text = "Missing Password"
            statusLabel.isHidden = false
            passwordEntry.backgroundColor = errorColor
            return
        }
        if password.count == 0 {
            statusLabel.text = "Missing Password"
            statusLabel.isHidden = false
            passwordEntry.backgroundColor = errorColor
            return
        }

        let (status, storedPassword) = KeychainManager.retrievePassword(username: username)
        
        guard status != .invalidKey else {
            statusLabel.text = "User not found"
            statusLabel.isHidden = false
            usernameEntry.backgroundColor = errorColor
            return
        }
        
        guard status == .success else {
            statusLabel.text = "Credential Error"
            statusLabel.isHidden = false
            return
        }

        guard storedPassword == password else {
            statusLabel.text = "Incorrect password"
            statusLabel.isHidden = false
            passwordEntry.backgroundColor = errorColor
            return
        }
        
        guard let user = UserManager.findUser(username: username) else {
            statusLabel.text = "Internal Error"
            statusLabel.isHidden = false
            return
        }
        UserManager.currentUser = user
        
        if persistenceToggle.isOn {
            UserDefaults.standard.set(username as Any?, forKey: "currentUser")
        }

        spinner.isHidden = false
        spinner.startAnimating()

        ControllerManager.mainTransition(navigationController: self.navigationController)
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
