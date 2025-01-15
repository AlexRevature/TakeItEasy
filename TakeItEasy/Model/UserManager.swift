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
    
    static func createUser(username: String) -> StoredUser? {
        let storedUser = StoredUser(context: CoreManager.managedContext)
        storedUser.username = username
        
        // Setup default books/quizes/notes/etc
        
        return storedUser
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
