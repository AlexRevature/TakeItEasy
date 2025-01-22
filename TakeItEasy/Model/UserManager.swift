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

        // Populate test data, remove when app finished
        populateTestQuizzes(storedUser: storedUser)

        // TODO: Populate actual data

        CoreManager.saveContext()
        return storedUser
    }

    private static func populateTestQuizzes(storedUser: StoredUser) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let count = 5

        for k in 0..<count {
            let storedQuiz = StoredQuiz(context: CoreManager.managedContext)
            var totalScore = 0
            for i in 0..<count {
                let storedQuestion = StoredQuestion(context: CoreManager.managedContext)
                for j in 0..<count {
                    let storedOption = StoredOption(context: CoreManager.managedContext)
                    storedOption.text = "(\(i+1), \(j+1)) Testing option"
                    storedOption.orderNumber = Int32(j)
                    storedQuestion.addToOptionSet(storedOption)
                }
                let pointValue = (i + 1) * 50
                totalScore += pointValue
                storedQuestion.text = "(\(i+1)) Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum pharetra pellentesque leo vel interdum. Proin ex neque, maximus ac aliquam vitae, aliquet rhoncus nisi."
                storedQuestion.orderNumber = Int32(i)
                storedQuestion.correctIndex = Int32(i % count)
                storedQuestion.pointValue = Int32(pointValue)
                storedQuiz.addToQuestionSet(storedQuestion)
            }
            storedQuiz.name = "Test #\(k+1)"
            storedQuiz.author = "Little Bobby Tables"
            storedQuiz.date = formatter.date(from: "2024/5/\(k+1)")
            storedQuiz.totalScore = Int32(totalScore)
            storedUser.addToQuizSet(storedQuiz)
        }
    }

    static func findUser(username: String) -> StoredUser? {
        let fetchRequest = StoredUser.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)
        
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
    
    static func getBookList() -> [StoredBook]? {
                
        let bookSet = currentUser!.bookSet as! Set<StoredBook>
        return bookSet.sorted(by: {a, b in
            a.name ?? "" < b.name ?? ""
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

    let questionList: [QuizInfo] = [
        .init(name: "Swift Language", author: "John Apple", date: Date(), image: UIImage(), questionList: [
            .init(text: "How would you force unwrap the optional variable 'tmp'?", value: 50, correctIndex: 0, options: [
                "tmp!",
                "tmp?",
                "!tmp",
                "tmp ?? nil",
                "tmp -> nTmp"
            ]),
            .init(text: "What keyword is used in a closure after listing its arguments?", value: 60, correctIndex: 3, options: [
                "perform",
                "do",
                "for",
                "in",
                "action"
            ]),
            .init(text: "What is the some keyword used for?", value: 90, correctIndex: 2, options: [
                "closures",
                "reference types",
                "opaque types",
                "ForLoop callback",
                "H-O value dereferencing"
            ]),
            .init(text: "Who created the Swift language?", value: 10, correctIndex: 4, options: [
                "Bobby Tables",
                "John Swift",
                "Graydon Hoare",
                "John Closure",
                "Christ Lattner"
            ]),
            .init(text: "Which of these is not a feature of the language?", value: 120, correctIndex: 0, options: [
                "Garbage Collection",
                "Closures",
                "Reference Counting",
                "Extensions",
                "Protocols"
            ]),
        ]),
        .init(name: "UIKit Features", author: "Johnathan Apple", date: Date(), image: UIImage(), questionList: [
            .init(text: "How do you navigate to a new viewController when using a Navigation Controller?", value: 50, correctIndex: 0, options: [
                "nav.pushViewController(vc)",
                "nav.present(vc)",
                "present(vc)",
                "nav.viewTransition(vc)",
                "addToQueue(vc)"
            ]),
            .init(text: "Which is not a valid core data entity attribute type?", value: 60, correctIndex: 3, options: [
                "String",
                "Int",
                "Date",
                "Boolean",
                "Float"
            ]),
            .init(text: "Which transition callback doesn't exist?", value: 90, correctIndex: 3, options: [
                "viewWillTransition",
                "viewIsAppearing",
                "viewDidLayoutSubviews",
                "viewWillSetMargins",
                "viewDidDisappear"
            ]),
            .init(text: "Which of these are properties of the main queue of the GCD?", value: 90, correctIndex: 2, options: [
                "serial and async",
                "concurrent and sync",
                "serial and sync",
                "concurrent and async",
                "N/A"
            ]),
            .init(text: "To what iOS layer does AVFoundation belong to?", value: 120, correctIndex: 2, options: [
                "Core OS",
                "Core Services",
                "Media",
                "Cocoa Touch",
                "N/A"
            ]),
        ])
    ]

    func populateQuizzes(storedUser: StoredUser, quizzes: [QuizInfo]) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"

        for (idx, quiz) in quizzes.enumerated() {
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
            storedQuiz.totalScore = Int32(totalScore)
            storedUser.addToQuizSet(storedQuiz)
        }
    }

}

struct QuizInfo {
    let name: String
    let author: String
    let date: Date
    let image: UIImage
    var questionList: [QuestionInfo]
}

struct QuestionInfo {
    let text: String
    let value: Int
    let correctIndex: Int
    var options: [String]
}
