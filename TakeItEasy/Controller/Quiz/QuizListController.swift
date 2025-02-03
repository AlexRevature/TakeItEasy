//
//  QuizListController.swift
//  TakeItEasy
//
//  Created by Alex Cabrera on 1/13/25.
//

import UIKit

class QuizListController: UIViewController {
    
    @IBOutlet weak var quizCollection: UICollectionView!

    // Retrieved from Core Data
    var quizList: [StoredQuiz]?

    override func viewDidLoad() {
        super.viewDidLoad()

        quizCollection.delegate = self
        quizCollection.dataSource = self

        quizList = UserManager.getQuizList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexes = quizCollection.indexPathsForSelectedItems {
            if !indexes.isEmpty {
                quizCollection.deselectItem(at: indexes[0], animated: true)
            }
        }
    }

}

extension QuizListController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quizList?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewQuizCell", for: indexPath) as! NewQuizCell
        let currentQuiz = quizList![indexPath.row]

        cell.imageHolder.tintColor = ThemeManager.primaryColor
        if currentQuiz.imageName != nil {
            cell.imageHolder.image = UIImage(systemName: currentQuiz.imageName!)
        } else {
            cell.imageHolder.image = UIImage(systemName: "circle")
        }
        cell.imageHolder.layer.cornerRadius = 12
        cell.imageHolder.backgroundColor = UIColor.systemGray5
        cell.imageHolder.clipsToBounds = true

        cell.titleLabel.text = currentQuiz.name
        cell.dateLabel.text = currentQuiz.date?.formatted(date: .abbreviated, time: .omitted)

        cell.countLabel.textColor = ThemeManager.alternateText
        cell.countLabel.text = "\(currentQuiz.questionSet?.count ?? 0) Qs"

        cell.countBack.backgroundColor = ThemeManager.secondaryColor
        cell.countBack.layer.cornerRadius = 5

        cell.backView.backgroundColor = ThemeManager.backColor
        cell.backView.layer.borderColor = UIColor.systemBackground.cgColor
        cell.backView.layer.borderWidth = 0.2

        cell.backView.layer.cornerRadius = 18.0
        cell.backView.layer.masksToBounds = false

        cell.backView.layer.shadowColor = UIColor.black.cgColor
        cell.backView.layer.shadowOpacity = 0.5
        cell.backView.layer.shadowOffset = CGSize(width: 4, height: 4)
        cell.backView.layer.shadowRadius = 4

        cell.backView.layer.shadowPath = UIBezierPath(
            roundedRect: cell.backView.bounds,
            cornerRadius: cell.backView.layer.cornerRadius
        ).cgPath

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "QuizStoryboard", bundle: nil)
        let quizController = storyboard.instantiateViewController(identifier: "QuizOverviewController") as! QuizOverviewController
        quizController.selectedQuiz = quizList![indexPath.row]
        self.navigationController?.pushViewController(quizController, animated: true)
    }
}

class QuizCell: UITableViewCell {
    
    @IBOutlet weak var imageHolder: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    
}

class NewQuizCell: UICollectionViewCell {
    
    @IBOutlet weak var imageHolder: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var countBack: UIView!
}
