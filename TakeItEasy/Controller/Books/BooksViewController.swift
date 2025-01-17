//
//  BooksViewController.swift
//  TakeItEasy
//
//  Created by admin on 1/14/25.
//

import UIKit
import PDFKit
import CoreData

class BooksViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, PDFViewDelegate {
    private let collectionSectionLimit = 20
    private let stringEmptyDataContainer = "No Books Available"
    private var categoryNames: [String] = []
    private var pdfView = PDFView()
    var sections: Dictionary<Int, String> = Dictionary()
    
    // MARK: - Builder Outlets, Actions, etc.
    
    @IBOutlet weak var searchBarTitleOrAuthor: UISearchBar!
    @IBOutlet weak var collectionBooks: UICollectionView!
    
    // MARK: - ViewController functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionBooks.delegate = self
        collectionBooks.dataSource = self
        pdfView = PDFView(frame: UIScreen.main.bounds)
        //testSetup()
        BooksManager.fetchBooks()
        categoryNames = BooksManager.getAllCategoryNames()
    }
    
    // MARK: - Test Function
    
    func testSetup() {
        let book1 = Book()
        let book2 = Book()
        let book3 = Book()
        
        book1.name = "Eleni"
        book1.authorNameLast = "Gage"
        book1.authorNameFirst = "Nicholas"
        book1.category = "Nonfiction"
        
        book2.authorNameLast = "Dumas"
        book2.authorNameFirst = "Alexandre"
        book2.name = "The Count of Monte Cristo"
        book2.category = "Historical Adventure"
        
        book3.authorNameLast = "Grisham"
        book3.authorNameFirst = "John"
        book3.name = "The Firm"
        book3.category = "Legal Thriller"
        
        BooksManager.addBook(items: [book1, book2, book3])
    }
    
    // MARK: - CollectionView functions
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellItem", for: indexPath) as! BooksCollectionViewCell
        
        if BooksManager.storedBooks.count > 0 {
            guard let coverImage = BooksManager.storedBooks[indexPath.row].coverImage else {
                return cell
            }
            //cell.bookCoverImage.image = UIImage(data: coverImage)
            return cell
        } else {
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if categoryNames.count > 1 {
            print(collectionView.dataSourceSectionIndex(forPresentationSectionIndex: 0))
            return 2
        } else {
            return 1
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if BooksManager.storedBooks.count > 1 {
            return categoryNames.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if BooksManager.storedBooks.count > 1 {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerItem", for: indexPath) as! BooksCollectionReusableView
            
            header.sectionName.text = stringEmptyDataContainer
            return header
        } else {
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerItem", for: indexPath) as! BooksCollectionReusableView
                
                header.sectionIndex = indexPath.section
                print("\(header.sectionIndex!)")
                
                guard let sectionName = sections[indexPath.section] else {
                    header.sectionName.text = "Uncategorized"
                    return header
                }
                header.sectionName.text = sectionName
                return header
            default:
                assert(false, "Invalid element")
            }
        }
    }
    
    // MARK: - Collection view supplement functions
    
    func countDataItemsInSection(section: String) -> Int {
        var count = 0
        
        for book in BooksManager.storedBooks {
            if section == book.category {
                count += 1
            }
        }
        return count
    }
    
    // MARK: - PDF viewer
    func viewDocument(url: URL) {
        pdfView.document = PDFDocument(url: url)
    }
    
    // MARK: - Navigation
    
    
}
