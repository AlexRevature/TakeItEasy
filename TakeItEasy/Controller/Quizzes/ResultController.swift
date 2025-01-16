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
    
    // Initialized by sender
    var currentQuiz: StoredQuiz?
    var score: Int = 0
    var charScore: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let maxScore = currentQuiz?.totalScore ?? 1
        let percentageScore = Float(score) / Float(maxScore)

        switch percentageScore {
            case let p where p == 1.0:
                charScore = "S"
            case let p where p >= 0.9:
                charScore = "A"
            case let p where p >= 0.8:
                charScore = "B"
            case let p where p >= 0.7:
                charScore = "C"
            case let p where p >= 0.6:
                charScore = "D"
            default:
                charScore = "F"
        }
        
        if percentageScore > 0.7 {
            messageLabel.text = "You did well!"
        } else {
            messageLabel.text = "Maybe try again?"
        }
        
        scoreLabel.text = "\(score)/\(maxScore)"
        
        letterGradeLabel.text = charScore
        backImage.tintColor = ThemeManager.lightTheme.primaryColor

    }
    
    @IBAction func exitAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
