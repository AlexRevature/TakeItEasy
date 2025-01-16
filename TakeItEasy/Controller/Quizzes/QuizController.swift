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
    
    var selectedQuiz: StoredQuiz?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        infoWrapper.layer.cornerRadius = 5
        infoWrapper.layer.masksToBounds = false

        infoWrapper.layer.shadowColor = UIColor.black.cgColor
        infoWrapper.layer.shadowOpacity = 0.5
        infoWrapper.layer.shadowOffset = CGSize(width: 4, height: 4)
        infoWrapper.layer.shadowRadius = 5
        infoWrapper.layer.shadowPath = UIBezierPath(
            roundedRect: infoWrapper.bounds,
            cornerRadius: infoWrapper.layer.cornerRadius
        ).cgPath

        titleLabel.text = selectedQuiz?.name
        authorLabel.text = selectedQuiz?.author
        scoreLabel.text = "Best Score: \(selectedQuiz?.maxScore ?? 0)/\((selectedQuiz?.questionSet?.count ?? 0) * 100)"
        
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
