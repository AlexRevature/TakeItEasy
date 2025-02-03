//
//  LandingController.swift
//  TakeItEasy
//
//  Created by Alex Cabrera on 1/14/25.
//

import UIKit

class LandingController: UIViewController {

    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var titleBack: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleBack.backgroundColor = nil

        logoView.image = .init(named: "icon")
        logoView.tintColor = ThemeManager.primaryColor
        logoView.layer.cornerRadius = 25
        logoView.backgroundColor = UIColor.systemGray5
        logoView.clipsToBounds = true

        backView.backgroundColor = ThemeManager.backColor
        backView.layer.cornerRadius = 30
        backView.layer.borderColor = UIColor.black.cgColor
        backView.layer.borderWidth = 0.2
        backView.layer.cornerRadius = 12
        backView.layer.masksToBounds = false
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOpacity = 0.2
        backView.layer.shadowOffset = CGSize(width: 6, height: 4)
        backView.layer.shadowRadius = 3
        backView.layer.shadowPath = UIBezierPath(
            roundedRect: backView.bounds,
            cornerRadius: backView.layer.cornerRadius
        ).cgPath

    }
    
    @IBAction func loginAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AccountStoryboard", bundle: nil)
        let loginController = storyboard.instantiateViewController(identifier: "LoginController")
        self.navigationController?.pushViewController(loginController, animated: true)
    }
    
    @IBAction func registerAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AccountStoryboard", bundle: nil)
        let loginController = storyboard.instantiateViewController(identifier: "RegisterController")
        self.navigationController?.pushViewController(loginController, animated: true)
    }

}
