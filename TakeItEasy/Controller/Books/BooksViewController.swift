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
        /// - Set up test data - delete on final deployment
        testUserDataCheck()
        /// - End test data - delete
        BooksManager.fetchBooks()
    }
    
    // MARK: - Test Functions - Delete before final deployment
    
    private func testUserDataCheck() {
        guard let currentUser = UserManager.currentUser?.username else {
            return
        }
        if currentUser == "testData" && BooksManager.storedBooks.count < 1 {
            testSetup()
        }
    }
    
    private func testSetup() {
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
        
        if BooksManager.storedBooks.count < 1 {
            cell.bookCoverImage.isHidden = true
            return cell
        } else {
            //guard let coverImage = BooksManager.storedBooks[indexPath.row].coverImage else {
            return cell
            //}
            //cell.bookCoverImage.image = UIImage(data: coverImage)
            //return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 2
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
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
    
    
    // MARK: - PDF viewer
    func viewDocument(url: URL) {
        pdfView.document = PDFDocument(url: url)
    }
    
    // MARK: - Navigation
    
    
}
