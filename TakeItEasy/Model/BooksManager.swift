//
//  BooksManager.swift
//  TakeItEasy
//
//  Created by admin on 1/15/25.
//

import CoreData

class BooksManager {
    lazy var dataContainer = NSPersistentContainer(name: "StoredBook")
    static var storedBooks = [StoredBook]()
    
    private init() {
    }
    
    static func fetchBooks() {
        let request: NSFetchRequest<StoredBook> = StoredBook.fetchRequest()
        let managedContext = CoreManager.managedContext
        let sortAuthor = NSSortDescriptor(key: "authorNameLast", ascending: true)
        let sortName = NSSortDescriptor(key: "name", ascending: true)
        var result = [StoredBook]()
        
        request.sortDescriptors = [sortName, sortAuthor]
        
        do {
            try result = managedContext.fetch(request)
        } catch let error {
            print("Unable to fetch book data: \(error)")
        }
        storedBooks = result
    }
    
    static func addBook(title: String, authorNameLast: String, authorNameFirst: String, releaseDate: Date) {
        let request: NSFetchRequest<StoredBook> = StoredBook.fetchRequest()
        let bookItem = StoredBook(context: CoreManager.managedContext)
        
        bookItem.name = title
        bookItem.authorNameLast = authorNameLast
        bookItem.authorNameFirst = authorNameFirst
        bookItem.releaseDate = releaseDate
        
        CoreManager.saveContext()
    }
}
