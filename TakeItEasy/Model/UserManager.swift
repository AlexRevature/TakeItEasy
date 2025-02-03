//
//  UserManager.swift
//  TakeItEasy
//
//  Created by Alex Cabrera on 1/13/25.
//

import CoreData
import UIKit

class UserManager {
    
    private init() {}
    
    static var currentUser: StoredUser?
    
    static func createUser(name: String, age: Int, email: String, username: String) -> StoredUser? {
        let storedUser = StoredUser(context: CoreManager.managedContext)
        storedUser.name = name
        storedUser.age = Int32(age)
        storedUser.email = email
        storedUser.username = username

        let noteA = StoredNote(context: CoreManager.managedContext)
        let noteB = StoredNote(context: CoreManager.managedContext)

        noteB.name = "New List"
        noteB.text = "- Bacon\n- Eggs"
        noteB.modifiedDate = Date()

        noteA.name = "New Note"
        noteA.text = "This is how your notes look\nUse notes to express yourself!"
        noteA.modifiedDate = Date()

        storedUser.addToNoteSet(noteA)
        storedUser.addToNoteSet(noteB)

        populateQuizzes(storedUser: storedUser, quizzes: DataManager.quizList)
        CoreManager.saveContext()
        return storedUser
    }

    static func findUser(username: String) -> StoredUser? {
        let fetchRequest = StoredUser.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", username.lowercased())
        
        do {
            let request = try CoreManager.managedContext.fetch(fetchRequest)
            if let storedUser = request.first {
                return storedUser
            }
        } catch {
            print("Error")
        }
        
        return nil
    }
    
    static func getQuizList() -> [StoredQuiz]? {
        
        let quizSet = currentUser!.quizSet as! Set<StoredQuiz>
        return quizSet.sorted(by: {a, b in
            a.date ?? Date() < b.date ?? Date()
        })
    }
    
    static func getNoteList() -> [StoredNote]? {
        
        let noteSet = currentUser!.noteSet as! Set<StoredNote>
        return noteSet.sorted(by: {a, b in
            a.modifiedDate ?? Date() < b.modifiedDate ?? Date()
        })
    }
    
    static func getQuestionList(storedQuiz: StoredQuiz) -> [StoredQuestion]? {
        let questionSet = storedQuiz.questionSet as! Set<StoredQuestion>
        return questionSet.sorted(by: {a, b in
            a.orderNumber < b.orderNumber
        })
    }
    
    static func getOptionList(storedQuestion: StoredQuestion) -> [StoredOption]? {
        
        // Note: Currently sorted by alphabetically by option content,
        // might want to add an order number in CoreData later.
        let optionSet = storedQuestion.optionSet as! Set<StoredOption>
        return optionSet.sorted(by: {a, b in
            a.orderNumber < b.orderNumber
        })
    }

    private static func populateQuizzes(storedUser: StoredUser, quizzes: [QuizInfo]) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"

        for (_, quiz) in quizzes.enumerated() {
            let storedQuiz = StoredQuiz(context: CoreManager.managedContext)
            var totalScore = 0

            for (jdx, question) in quiz.questionList.enumerated() {
                let storedQuestion = StoredQuestion(context: CoreManager.managedContext)

                for (kdx, option) in question.options.enumerated() {
                    let storedOption = StoredOption(context: CoreManager.managedContext)
                    storedOption.text = option
                    storedOption.orderNumber = Int32(kdx)
                    storedQuestion.addToOptionSet(storedOption)
                }

                totalScore += question.value
                storedQuestion.text = question.text
                storedQuestion.orderNumber = Int32(jdx)
                storedQuestion.correctIndex = Int32(question.correctIndex)
                storedQuestion.pointValue = Int32(question.value)
                storedQuiz.addToQuestionSet(storedQuestion)
            }
            storedQuiz.name = quiz.name
            storedQuiz.author = quiz.author
            storedQuiz.date = quiz.date
            storedQuiz.imageName = quiz.imageName
            storedQuiz.totalScore = Int32(totalScore)
            storedUser.addToQuizSet(storedQuiz)
        }
    }

}

struct QuizInfo {
    let name: String
    let author: String
    let date: Date
    let imageName: String
    var questionList: [QuestionInfo]
}

struct QuestionInfo {
    let text: String
    let value: Int
    let correctIndex: Int
    var options: [String]
}
