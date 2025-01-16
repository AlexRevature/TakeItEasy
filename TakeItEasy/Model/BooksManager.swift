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
        let context = CoreManager.persistentContainer.viewContext
        let sortAuthor = NSSortDescriptor(key: "authorNameLast", ascending: true)
        let sortName = NSSortDescriptor(key: "name", ascending: true)
        var result = [StoredBook]()
        
        request.sortDescriptors = [sortName, sortAuthor]
        
        do {
            try result = context.fetch(request)
        } catch let error {
            print("Unable to fetch book data: \(error)")
        }
        storedBooks = result
    }
    
    static func addBook(item: StoredBook) {
        let newStoredBook = StoredBook(context: CoreManager.persistentContainer.viewContext)
        
        newStoredBook.name = item.name
        newStoredBook.authorNameLast = item.authorNameLast
        newStoredBook.authorNameFirst = item.authorNameFirst
        newStoredBook.category = item.category
        newStoredBook.coverImage = item.coverImage
        newStoredBook.fileData = item.fileData
        
        CoreManager.saveContext()
    }
    
    static func deleteBook(indexPath: Int, items: [StoredBook]) {
        let context = CoreManager.persistentContainer.viewContext
        let deleteTarget = items[indexPath]
        
        context.delete(deleteTarget)
        CoreManager.saveContext()
    }
}
