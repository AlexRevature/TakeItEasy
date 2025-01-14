//
//  LandingController.swift
//  TakeItEasy
//
//  Created by Alex Cabrera on 1/14/25.
//

import UIKit

class LandingController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
