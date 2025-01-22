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
    static var categorizedBooks: Dictionary<Int, [StoredBook]> = Dictionary()
    static var bookCategories: [String] = []
    static let dataEmptyMessage = "Data Currently Unavailable"
    
    private init() {
    }
    
    static func fetchBooks() {
        let request = StoredBook.fetchRequest()
        let context = CoreManager.persistentContainer.viewContext
        var result = [StoredBook]()
        var categoriesSet: Set<String> = Set()
        
        do {
            try result = context.fetch(request)
        } catch let error {
            print("Unable to fetch book data: \(error)")
        }
        storedBooks = result
        // Define categorization reference
        for book in storedBooks {
            guard let category = book.category else {
                continue
            }
            categoriesSet.insert(category)
        }
        bookCategories = Array(categoriesSet)
        
        // Arrange [section, item] coordinate collection
        for category in bookCategories {
            guard let index = bookCategories.firstIndex(of: category) else {
                continue
            }
            categorizedBooks[index] = []
        }
        
        for book in storedBooks {
            guard let category = book.category, let index = bookCategories.firstIndex(of: category) else {
                continue
            }
            categorizedBooks[index]?.append(book)
        }
    }
    
    static func addBook(items: [Book]) {
        let context = CoreManager.persistentContainer.viewContext
        
        for item in items {
            let newStoredBook = StoredBook(context: context)
            
            newStoredBook.name = item.name
            newStoredBook.authorNameLast = item.authorNameLast
            newStoredBook.authorNameFirst = item.authorNameFirst
            newStoredBook.category = item.category
            //newStoredBook.coverImage = item.coverImage
            //newStoredBook.fileData = item.fileData
        }
        CoreManager.saveContext()
        print("Data updated")
    }
    
    static func deleteBook(indexPath: Int, items: [StoredBook]) {
        let context = CoreManager.persistentContainer.viewContext
        let deleteTarget = items[indexPath]
        
        context.delete(deleteTarget)
        CoreManager.saveContext()
    }
}
