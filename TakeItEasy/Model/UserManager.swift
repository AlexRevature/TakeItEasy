//
//  UserManager.swift
//  TakeItEasy
//
//  Created by Alex Cabrera on 1/13/25.
//

import CoreData

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

        for k in 0..<4 {
            let storedQuiz = StoredQuiz(context: CoreManager.managedContext)
            for i in 0..<4 {
                let storedQuestion = StoredQuestion(context: CoreManager.managedContext)
                for j in 0..<4 {
                    let storedOption = StoredOption(context: CoreManager.managedContext)
                    storedOption.text = "(\(i+1), \(j+1)) Testing option"
                    storedOption.orderNumber = Int32(j)
                    storedQuestion.addToOptionSet(storedOption)
                }
                storedQuestion.text = "(\(i+1)) Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum pharetra pellentesque leo vel interdum. Proin ex neque, maximus ac aliquam vitae, aliquet rhoncus nisi."
                storedQuestion.orderNumber = Int32(i)
                storedQuestion.correctIndex = Int32(i % 4)
                storedQuiz.addToQuestionSet(storedQuestion)
            }
            storedQuiz.name = "Test #\(k+1)"
            storedQuiz.author = "Bobby Tables #\(k+1)"
            storedQuiz.date = formatter.date(from: "2024/5/\(k+1)")
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
    
}
