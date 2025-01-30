//
//  ResultController.swift
//  TakeItEasy
//
//  Created by Alex Cabrera on 1/15/25.
//

import UIKit

class ResultController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var letterGradeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var backView: UIView!

    @IBOutlet weak var updateBack: UIView!
    @IBOutlet weak var updateLabel: UILabel!
    
    // Initialized by sender
    var currentQuiz: StoredQuiz?
    var score: Int = 0
    var charScore: String?
    var pointUpdate: Int32?

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

        let maxScore = currentQuiz?.totalScore ?? 1
        let percentageScore = Float(score) / Float(maxScore)

        switch percentageScore {
            case let p where p == 1.0:
                charScore = "A"
            case let p where p >= 0.8:
                charScore = "B"
            case let p where p >= 0.6:
                charScore = "C"
            case let p where p >= 0.4:
                charScore = "D"
            default:
                charScore = "F"
        }
        
        if percentageScore > 0.6 {
            messageLabel.text = "You did well!"
        } else {
            messageLabel.text = "Maybe try again?"
        }
        
        scoreLabel.text = "\(score)/\(maxScore)"
        
        letterGradeLabel.text = charScore
        backImage.tintColor = ThemeManager.primaryColor

        updateBack.layer.cornerRadius = 5
        updateBack.backgroundColor = ThemeManager.backColor

        if let pointUpdate {
            var updateString = "You gained \(pointUpdate) point"
            if pointUpdate != 1 {
                updateString += "s"
            }
            updateLabel.text = updateString
        } else {
            updateLabel.text = "No points gained"
        }

    }
    
    @IBAction func exitAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
