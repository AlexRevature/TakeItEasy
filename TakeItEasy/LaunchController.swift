//
//  LaunchController.swift
//  TakeItEasy
//
//  Created by Alex Cabrera on 1/31/25.
//

import UIKit

class LaunchController: UIViewController {

    @IBOutlet weak var iconHolder: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        iconHolder.clipsToBounds = true
        iconHolder.layer.cornerRadius = 10

        spinner.startAnimating()
    }

}
