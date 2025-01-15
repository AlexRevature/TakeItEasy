//
//  QuizListController.swift
//  TakeItEasy
//
//  Created by Alex Cabrera on 1/13/25.
//

import UIKit

class QuizListController: UIViewController {
    
    @IBOutlet weak var quizTable: UITableView!
    
    var quizList: [StoredQuiz]? = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        var tList: [StoredQuiz] = []
        for k in 1...4 {
            let storedQuiz = StoredQuiz(context: CoreManager.managedContext)
            for i in 1...4 {
                let storedQuestion = StoredQuestion(context: CoreManager.managedContext)
                for j in 1...4 {
                    let storedOption = StoredOption(context: CoreManager.managedContext)
                    storedOption.text = "(\(i), \(j)) Testing option"
                    storedQuestion.addToOptionSet(storedOption)
                }
                storedQuestion.text = "(\(i)) Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum pharetra pellentesque leo vel interdum. Proin ex neque, maximus ac aliquam vitae, aliquet rhoncus nisi."
                storedQuestion.orderNumber = Int32(i)
                storedQuiz.addToQuestionSet(storedQuestion)
            }
            storedQuiz.name = "Test \(k)"
            storedQuiz.date = formatter.date(from: "2024/5/\(k)")
            tList.append(storedQuiz)
        }
        return tList
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        quizTable.delegate = self
        quizTable.dataSource = self
//        quizList = UserManager.getQuizList()
    }

}

extension QuizListController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCell", for: indexPath) as! QuizCell
        let currentQuiz = quizList![indexPath.row]
        
        cell.imageHolder.tintColor = ThemeManager.lightTheme.primaryColor
        cell.imageHolder.image = UIImage(systemName: "circle")
        cell.titleLabel.text = currentQuiz.name
        cell.dateLabel.text = currentQuiz.date?.formatted(date: .abbreviated, time: .omitted)
        
        cell.backView.layer.borderColor = UIColor.black.cgColor
        cell.backView.layer.borderWidth = 1.0
        cell.backView.layer.cornerRadius = 30.0
        cell.backView.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "QuizzesStoryboard", bundle: nil)
        let quizController = storyboard.instantiateViewController(identifier: "QuizController") as! QuizController
        quizController.selectedQuiz = quizList![indexPath.row]
        self.navigationController?.pushViewController(quizController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") {_,_,_ in
            
            let object = self.quizList?.remove(at: indexPath.row)
            if let object {
                CoreManager.managedContext.delete(object)
            }
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}

class QuizCell: UITableViewCell {
    
    @IBOutlet weak var imageHolder: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
}
