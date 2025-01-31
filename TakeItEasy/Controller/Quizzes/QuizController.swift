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

    // Initialized by sender
    var selectedQuiz: StoredQuiz?
    
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

        infoWrapper.backgroundColor = ThemeManager.secondaryColor
        infoWrapper.layer.cornerRadius = 12
        infoWrapper.layer.masksToBounds = false

        titleLabel.text = selectedQuiz?.name
        titleLabel.textColor = ThemeManager.alternateText

        authorLabel.text = "By: \(selectedQuiz?.author ?? "N/A")"
        authorLabel.textColor = ThemeManager.alternateText

        scoreWrapper.layer.cornerRadius = 8

        if selectedQuiz?.imageName != nil {
            imageHolder.image = UIImage(systemName: selectedQuiz!.imageName!)
        } else {
            imageHolder.image = UIImage(systemName: "circle")
        }
        imageHolder.tintColor = ThemeManager.primaryColor
        imageHolder.layer.cornerRadius = 20
        imageHolder.backgroundColor = UIColor.systemGray5
        imageHolder.clipsToBounds = true

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        scoreLabel.text = "\(selectedQuiz?.maxScore ?? 0)/\(selectedQuiz?.totalScore ?? 0)"
    }

    // Start quiz, segue to QuestionController
    @IBAction func startAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "QuizzesStoryboard", bundle: nil)
        let questionController = storyboard.instantiateViewController(identifier: "QuestionController") as! QuestionController
        questionController.currentQuiz = selectedQuiz
        self.navigationController?.pushViewController(questionController, animated: true)
    }

}
