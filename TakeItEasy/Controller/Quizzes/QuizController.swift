//
//  QuizController.swift
//  TakeItEasy
//
//  Created by Alex Cabrera on 1/15/25.
//

import UIKit

class QuizController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var infoWrapper: UIView!
    @IBOutlet weak var imageHolder: UIImageView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreWrapper: UIView!
    @IBOutlet weak var backView: UIView!
    
    var selectedQuiz: StoredQuiz?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backView.backgroundColor = ThemeManager.lightTheme.backColor
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

        infoWrapper.backgroundColor = ThemeManager.lightTheme.secondaryColor
        infoWrapper.layer.cornerRadius = 12
        infoWrapper.layer.masksToBounds = false

        titleLabel.text = selectedQuiz?.name
        titleLabel.textColor = ThemeManager.lightTheme.alternateText

        authorLabel.text = "By: \(selectedQuiz?.author ?? "N/A")"
        authorLabel.textColor = ThemeManager.lightTheme.alternateText

        scoreLabel.text = "\(selectedQuiz?.maxScore ?? 0)/\(selectedQuiz?.totalScore ?? 0)"
        scoreWrapper.layer.cornerRadius = 8

        imageHolder.tintColor = ThemeManager.lightTheme.primaryColor

    }
    
    // Start quiz, segue to QuestionController
    @IBAction func startAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "QuizzesStoryboard", bundle: nil)
        let questionController = storyboard.instantiateViewController(identifier: "QuestionController") as! QuestionController
        questionController.currentQuiz = selectedQuiz
        self.navigationController?.pushViewController(questionController, animated: true)
    }

}
