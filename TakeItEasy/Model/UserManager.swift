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

        populateQuizzes(storedUser: storedUser, quizzes: quizList)
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

    static let quizList: [QuizInfo] = [
        .init(name: "Swift Language", author: "John Apple", date: Date(), imageName: "swift", questionList: [
            .init(text: "How would you force unwrap the optional variable 'tmp'?", value: 50, correctIndex: 0, options: [
                "tmp!",
                "tmp?",
                "!tmp",
                "tmp ?? nil",
                "tmp -> nTmp"
            ]),
            .init(text: "What keyword/symbol is used in a closure after listing its arguments?", value: 60, correctIndex: 3, options: [
                "perform",
                "do",
                "->",
                "in",
                "action"
            ]),
            .init(text: "What is the 'some' keyword used for?", value: 90, correctIndex: 2, options: [
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
            ])
        ]),
        .init(name: "UIKit Features", author: "Johnathan Apple", date: Date(), imageName: "square", questionList: [
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
            .init(text: "Which transition callback doesn't exist?", value: 80, correctIndex: 3, options: [
                "viewWillTransition",
                "viewIsAppearing",
                "viewDidLayoutSubviews",
                "viewWillSetMargins",
                "viewDidDisappear"
            ]),
            .init(text: "Which of these are properties of the main queue of the GCD?", value: 150, correctIndex: 2, options: [
                "serial and async",
                "concurrent and sync",
                "serial and sync",
                "concurrent and async",
                "N/A"
            ]),
            .init(text: "To what iOS layer does AVFoundation belong to?", value: 40, correctIndex: 2, options: [
                "Core OS",
                "Core Services",
                "Media",
                "Cocoa Touch",
                "N/A"
            ])
        ]),
        .init(name: "Design Patterns", author: "Joe Apple", date: Date(), imageName: "pencil", questionList: [
            .init(text: "Which of these is not a SOLID principle?", value: 80, correctIndex: 4, options: [
                "Dependency Inversion",
                "Lizkov Substitution",
                "Interface Segregation",
                "Single Responsibility",
                "Order First"
            ]),
            .init(text: "What design does the Elm framework use?", value: 60, correctIndex: 2, options: [
                "Model-View-Controller",
                "Model-View-Presenter",
                "Model-View-Update",
                "Model-View-ViewModel",
                "Presentation-Abstraction"
            ]),
            .init(text: "What does KVO stand for?", value: 40, correctIndex: 0, options: [
                "Key Value Observation",
                "Known Vector Organizer",
                "Key Value Operation",
                "Known Variable Optimization",
                "Kind Variable Operation"
            ]),
            .init(text: "What keyword-pair is necessary to (generally) create a singleton?", value: 100, correctIndex: 2, options: [
                "static func",
                "some func",
                "final struct",
                "static var/let",
                "some var/let"
            ]),
            .init(text: "Which of these is not a delegate protocol in Swift?", value: 120, correctIndex: 1, options: [
                "UITableViewDelegate",
                "UILocationDelegate",
                "AVAudioPlayerDelegate",
                "WKNavigationDelegate",
                "UICollectionViewDelegate"
            ])
        ]),
        .init(name: "Potpourri", author: "George Apple", date: Date(), imageName: "carrot", questionList: [
            .init(text: "What is the key difference between MVC and MVVM?", value: 50, correctIndex: 0, options: [
                "Data binding",
                "Location services",
                "Model structure",
                "Protocol permissions",
                "N/A"
            ]),
            .init(text: "Which of these is persisted after an app is deleted?", value: 60, correctIndex: 1, options: [
                "CoreData objects",
                "Keychain entries",
                "UserDefault values",
                "'opaque' arrays",
                "SceneDelegate variables"
            ]),
            .init(text: "Which of these is not a package manager for Swift dependencies?", value: 90, correctIndex: 3, options: [
                "Swift pm",
                "CocoaPods",
                "Accio",
                "Homebrew",
                "Carthage"
            ]),
            .init(text: "Where are swift primitive types (Int/Double/etc) provided?", value: 90, correctIndex: 2, options: [
                "Core Swift language",
                "Swift Standarl Library",
                "CoreFoundation",
                "Swift Foundation",
                "N/A"
            ]),
            .init(text: "For which of these can you NOT use 'extension'?", value: 120, correctIndex: 0, options: [
                "func",
                "class",
                "struct",
                "enum",
                "protocol"
            ])
        ]),
        .init(name: "Trivia", author: "Gregory Apple", date: Date(), imageName: "newspaper", questionList: [
            .init(text: "What is the world population as of January 2025", value: 50, correctIndex: 0, options: [
                "8.2 billion",
                "7.9 billion",
                "8.1 billion",
                "7.2 billion",
                "7.8 billion"
            ]),
            .init(text: "What's the real name of the xkcd creator?", value: 70, correctIndex: 1, options: [
                "Jacob Geller",
                "Randall Munroe",
                "Joseph Keppler",
                "Amy Hwang",
                "Jim Davis"
            ]),
            .init(text: "How many of the top ten highest grossing films (Jan 2025) aren't part of a franchise, or a remake?", value: 40, correctIndex: 4, options: [
                "0",
                "4",
                "None",
                "6",
                "1"
            ]),
            .init(text: "Can a match box?", value: 90, correctIndex: 2, options: [
                "Yes",
                "No",
                "No, but a tin can",
                "Yes, one beat Mike Tyson",
                "+500 points"
            ]),
            .init(text: "What is the capital of Kazakhstan?", value: 500, correctIndex: 3, options: [
                "Dushanbe",
                "Ashgabat",
                "Tashkent",
                "Astana",
                "Bishkek"
            ])
        ])
    ]

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
