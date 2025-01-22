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
        BooksManager.fetchBooks()
        // - Set up test data - delete on final deployment
        testUserDataCheck()
        // - End test data - delete
    }
    
    // MARK: - Test Functions - Delete before final deployment
    
    private func testUserDataCheck() {
        guard let currentUser = UserManager.currentUser?.username else {
            return
        }
        if currentUser != "testNoData" && BooksManager.storedBooks.count < 1 {
            testSetup()
        } else if currentUser == "testNoData" && BooksManager.storedBooks.count > 0 {
            testEmptyData()
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
        BooksManager.fetchBooks()
    }
    
    func testEmptyData() {
        // Implement core data wipe
    }
    
    // MARK: - CollectionView functions
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellItem", for: indexPath) as! BooksCollectionViewCell
        let item = indexPath.item
        
        cell.bookCoverImage.tintColor = ThemeManager.lightTheme.primaryColor
        cell.labelTitle.textColor = ThemeManager.lightTheme.alternateText
        cell.backView.backgroundColor = ThemeManager.lightTheme.backColor
        cell.backView.layer.borderColor = UIColor.systemBackground.cgColor
        cell.backView.layer.borderWidth = 0.2
        cell.backView.layer.cornerRadius = 18.0
        cell.backView.layer.masksToBounds = false
        cell.backView.layer.shadowColor = UIColor.black.cgColor
        cell.backView.layer.shadowOpacity = 0.5
        cell.backView.layer.shadowOffset = CGSize(width: 4, height: 4)
        cell.backView.layer.shadowRadius = 4
        cell.backView.layer.shadowPath = UIBezierPath(
            roundedRect: cell.backView.bounds,
            cornerRadius: cell.backView.layer.cornerRadius
        ).cgPath
        
        
        if indexPath.section < BooksManager.bookCategories.count, let categorySection = BooksManager.categorizedBooks[indexPath.section] {
            let itemData = categorySection[item]
            cell.labelTitle.text = itemData.name
        } else {
            cell.bookCoverImage.isHidden = true
            cell.labelTitle.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        
        for item in BooksManager.storedBooks {
            if item.category == BooksManager.bookCategories[section] {
                count += 1
            }
        }
        
        return count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if BooksManager.storedBooks.count < 1 {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerItem", for: indexPath) as! BooksCollectionReusableView
            
            header.sectionName.text = stringEmptyDataContainer
            return header
        } else {
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerItem", for: indexPath) as! BooksCollectionReusableView
                
                header.sectionIndex = indexPath.section
                if (indexPath.section < BooksManager.bookCategories.count) {
                    
                    header.sectionName.text = BooksManager.bookCategories[indexPath.section]
                    
                    return header
                } else {
                    header.sectionName.text = BooksManager.dataEmptyMessage
                    return header
                }
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
