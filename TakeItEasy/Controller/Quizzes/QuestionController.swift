//
//  QuestionController.swift
//  TakeItEasy
//
//  Created by Alex Cabrera on 1/13/25.
//

import UIKit

class QuestionController: UIViewController {
    
    @IBOutlet weak var optionTable: UITableView!
    @IBOutlet weak var questionLabel: QuestionLabel!
    @IBOutlet weak var scoreImage: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var numberButton: UIButton!
    
    // Initialized by sender
    var currentQuiz: StoredQuiz?
    
    // Initialized in viewDidLoad(), updated later
    var questionList: [StoredQuestion]?
    var answerSelection: [Int?]?
    var currentQuestionIndex: Int?
    var currentOptions: [StoredOption]?
    
    // Score tracking
    var score = 0
    var numAnswered = 0

    var currentQuestion: StoredQuestion? {
        if let currentQuestionIndex {
            return questionList?[currentQuestionIndex]
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let currentQuiz {
            questionList = UserManager.getQuestionList(storedQuiz: currentQuiz)
            answerSelection = [Int?](repeating: nil, count: questionList!.count)
            currentQuestionIndex = 0
            prevButton.isEnabled = false
            
            if questionList?.count == 1 {
                nextButton.isEnabled = false
            }
        }
        score = 0
        
        scoreImage.tintColor = ThemeManager.lightTheme.primaryColor
        
        questionLabel.textColor = ThemeManager.lightTheme.normalText
        questionLabel.contentMode = .bottom
        questionLabel.lineBreakMode = .byWordWrapping
        questionLabel.numberOfLines = 0
        
        optionTable.delegate = self
        optionTable.dataSource = self
        
        prevButton.setTitle("Previous", for: .normal)
        nextButton.setTitle("Next", for: .normal)
        
        numberButton.setTitleColor(.black, for: .normal)
        numberButton.backgroundColor = .lightGray
        numberButton.layer.cornerRadius = 6
        numberButton.clipsToBounds = true

        self.navigationItem.rightBarButtonItem = UIBarButtonItem (
            title: "Finish",
            style: .done,
            target: self,
            action: #selector(finishButtonAction)
        )

        updateQuestion()
    }

    @objc
    func finishButtonAction() {
        finishQuiz(delay: 0)
    }

    func finishQuiz(delay: Double) {
        let storyboard = UIStoryboard(name: "QuizzesStoryboard", bundle: nil)
        let resultController = storyboard.instantiateViewController(identifier: "ResultController") as! ResultController

        resultController.currentQuiz = currentQuiz
        resultController.score = score

        var viewControllers = self.navigationController?.viewControllers
        _ = viewControllers?.popLast()
        viewControllers?.append(resultController)

        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.leftBarButtonItem?.isEnabled = false

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.navigationController?.setViewControllers(viewControllers!, animated: true)
        }

        return
    }

    func updateQuestion() {
        
        if let currentQuestion {
            questionLabel.text = currentQuestion.text
            currentOptions = UserManager.getOptionList(storedQuestion: currentQuestion)
            numberButton.setTitle("\(currentQuestionIndex! + 1)", for: .normal)
            
            if answerSelection![currentQuestionIndex!] != nil {
                optionTable.isUserInteractionEnabled = false
            } else {
                optionTable.isUserInteractionEnabled = true
            }
        }
        scoreLabel.text = "\(score * 100)"
        optionTable.reloadData()

        if numAnswered >= questionList!.count {
            finishQuiz(delay: 1)
        }
    }
    
    @IBAction func prevAction(_ sender: Any) {
        
        if currentQuestionIndex != nil {
            if currentQuestionIndex! > 0 {
                currentQuestionIndex! -= 1
                
                if currentQuestionIndex! <= 0 {
                    prevButton.isEnabled = false
                }
                nextButton.isEnabled = true
            }
        }
        updateQuestion()
    }
    
    @IBAction func nextAction(_ sender: Any) {
        
        if currentQuestionIndex != nil {
            if currentQuestionIndex! < (questionList!.count - 1) {
                currentQuestionIndex! += 1
                
                if currentQuestionIndex! >= questionList!.count - 1 {
                    nextButton.isEnabled = false
                }
                prevButton.isEnabled = true
            }
        }
        updateQuestion()
    }
    
    @IBAction func submitAction(_ sender: Any) {
        
        // TODO: Transition to results screen
    }

}

extension QuestionController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentOptions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath) as! OptionCell

        cell.backView.layer.cornerRadius = 14.0
        cell.backView.layer.masksToBounds = false
        cell.backView.layer.borderWidth = 0.2
        cell.backView.layer.borderColor = UIColor.black.cgColor

        cell.backView.layer.shadowColor = UIColor.black.cgColor
        cell.backView.layer.shadowOpacity = 0.5
        cell.backView.layer.shadowOffset = CGSize(width: 5, height: 4)
        cell.backView.layer.shadowRadius = 4

        cell.backView.layer.shadowPath = UIBezierPath(
            roundedRect: cell.backView.bounds,
            cornerRadius: cell.backView.layer.cornerRadius
        ).cgPath
        
        cell.numberWrapper.layer.cornerRadius = 17.0
        cell.numberWrapper.backgroundColor = UIColor.systemGray4
        
        if answerSelection![currentQuestionIndex!] == indexPath.row {
            cell.backView.backgroundColor = ThemeManager.lightTheme.secondaryColor
            if indexPath.row == currentQuestion!.correctIndex {
                cell.numberWrapper.backgroundColor = .systemGreen
            } else {
                cell.numberWrapper.backgroundColor = .systemRed
            }
        } else {
            cell.backView.backgroundColor = .white
        }
        
        cell.numberLabel.text = "\(indexPath.row + 1)"
        cell.contentLabel.text = currentOptions?[indexPath.row].text
        cell.contentLabel.textColor = ThemeManager.lightTheme.normalText
        
        cell.layer.shadowRadius = 5
        cell.layer.shadowOpacity = 0.5
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if answerSelection![currentQuestionIndex!] == nil {
            if indexPath.row == currentQuestion!.correctIndex {
                score += 1
            }
            numAnswered += 1
            answerSelection![currentQuestionIndex!] = indexPath.row
            updateQuestion()
        }
    }
    
}

class OptionCell: UITableViewCell {
    @IBOutlet weak var numberWrapper: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
}

class QuestionLabel: UILabel {
    override func drawText(in rect: CGRect) {
        var newRect = rect
        switch contentMode {
        case .top:
            newRect.size.height = sizeThatFits(rect.size).height
        case .bottom:
            let height = sizeThatFits(rect.size).height
            newRect.origin.y += rect.size.height - height
            newRect.size.height = height
        default:
            ()
        }
        
        super.drawText(in: newRect)
    }
}
