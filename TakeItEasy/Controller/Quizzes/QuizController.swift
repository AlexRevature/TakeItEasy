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
        
        titleLabel.text = selectedQuiz?.name
        authorLabel.text = "Tmp"
        scoreLabel.text = "Best Run: \(selectedQuiz?.maxScore ?? 0)/\(selectedQuiz?.questionSet?.count ?? 0)"

        // Do any additional setup after loading the view.
    }
    
    // Start quiz, segue to QuestionController
    @IBAction func startAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "QuizzesStoryboard", bundle: nil)
        let questionController = storyboard.instantiateViewController(identifier: "QuestionController") as! QuestionController
        questionController.currentQuiz = selectedQuiz
        self.navigationController?.pushViewController(questionController, animated: true)
    }

}
