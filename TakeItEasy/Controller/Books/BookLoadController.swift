//
//  BookLoadController.swift
//  TakeItEasy
//
//  Created by Alex Cabrera on 1/31/25.
//

import UIKit

class BookLoadController: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imageHolder: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var selectedBook: BookInfo?

    override func viewDidLoad() {
        super.viewDidLoad()

        backView.backgroundColor = ThemeManager.backColor
        backView.layer.borderColor = UIColor.black.cgColor
        backView.layer.borderWidth = 0.2
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

        imageHolder.image = selectedBook?.image
        titleLabel.text = selectedBook?.title
        authorLabel.text = selectedBook?.author

        spinner.startAnimating()
    }

}
