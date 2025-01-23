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
    @IBOutlet weak var collectionTop: UICollectionView!
    @IBOutlet weak var collectionMiddle: UICollectionView!
    @IBOutlet weak var collectionBottom: UICollectionView!
    @IBOutlet weak var labelCollectionBottom: UILabel!
    @IBOutlet weak var labelCollectionMiddle: UILabel!
    @IBOutlet weak var labelCollectionTop: UILabel!
    
    // MARK: - ViewController functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionBottom.delegate = self
        collectionBottom.dataSource = self
        collectionMiddle.delegate = self
        collectionMiddle.dataSource = self
        collectionTop.delegate = self
        collectionTop.dataSource = self
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
        let categories = BooksManager.bookCategories
        
        if collectionView == collectionTop {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellForTop", for: indexPath) as! BooksCollectionViewCellTop
                cell.bookCoverImage.tintColor = ThemeManager.lightTheme.primaryColor
                cell.backView.backgroundColor = ThemeManager.lightTheme.backColor
                cell.backView.layer.borderColor = UIColor.systemBackground.cgColor
                cell.backView.layer.borderWidth = 0.2
                cell.backView.layer.cornerRadius = 18.0
                cell.backView.layer.masksToBounds = false
                cell.backView.layer.shadowColor = UIColor.black.cgColor
                cell.backView.layer.shadowOpacity = 0.5
                cell.backView.layer.shadowRadius = 4
                cell.backView.layer.shadowOffset = CGSizeMake(2, 2)
                cell.backView.layer.shadowPath = UIBezierPath(
                    roundedRect: cell.backView.bounds,
                    cornerRadius: cell.backView.layer.cornerRadius
                ).cgPath
            
            if let categorySection = BooksManager.categorizedBooks[0] {
                let itemData = categorySection[indexPath.item]
                cell.labelTitle.text = itemData.name
                print("Title: \(itemData.name!)")
            } else {
                cell.bookCoverImage.isHidden = true
                cell.labelTitle.isHidden = true
            }
            return cell
        } else if collectionView == collectionMiddle {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellForMiddle", for: indexPath) as! BooksCollectionViewCellMiddle
            
            cell.bookCoverImage.tintColor = ThemeManager.lightTheme.primaryColor
            cell.backView.backgroundColor = ThemeManager.lightTheme.backColor
            cell.backView.layer.borderColor = UIColor.systemBackground.cgColor
            cell.backView.layer.borderWidth = 0.2
            cell.backView.layer.cornerRadius = 18.0
            cell.backView.layer.masksToBounds = false
            cell.backView.layer.shadowColor = UIColor.black.cgColor
            cell.backView.layer.shadowOpacity = 0.5
            cell.backView.layer.shadowRadius = 4
            cell.backView.layer.shadowOffset = CGSizeMake(2, 2)
            cell.backView.layer.shadowPath = UIBezierPath(
                roundedRect: cell.backView.bounds,
                cornerRadius: cell.backView.layer.cornerRadius
            ).cgPath
            return cell
            
            if let categorySection = BooksManager.categorizedBooks[1] {
                let itemData = categorySection[indexPath.item]
                cell.labelTitle.text = itemData.name
                print("Title: \(itemData.name!)")
            } else {
                cell.bookCoverImage.isHidden = true
                cell.labelTitle.isHidden = true
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellforBottom", for: indexPath) as! BooksCollectionViewCellBottom
            cell.bookCoverImage.tintColor = ThemeManager.lightTheme.primaryColor
            cell.backView.backgroundColor = ThemeManager.lightTheme.backColor
            cell.backView.layer.borderColor = UIColor.systemBackground.cgColor
            cell.backView.layer.borderWidth = 0.2
            cell.backView.layer.cornerRadius = 18.0
            cell.backView.layer.masksToBounds = false
            cell.backView.layer.shadowColor = UIColor.black.cgColor
            cell.backView.layer.shadowOpacity = 0.5
            cell.backView.layer.shadowRadius = 4
            cell.backView.layer.shadowOffset = CGSizeMake(2, 2)
            cell.backView.layer.shadowPath = UIBezierPath(
                roundedRect: cell.backView.bounds,
                cornerRadius: cell.backView.layer.cornerRadius
            ).cgPath
            
            if let categorySection = BooksManager.categorizedBooks[2] {
                let itemData = categorySection[indexPath.item]
                cell.labelTitle.text = itemData.name
                print("Title: \(itemData.name!)")
            } else {
                cell.bookCoverImage.isHidden = true
                cell.labelTitle.isHidden = true
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionTop {
            guard let data = BooksManager.categorizedBooks[0] else {
                return 0
            }
            return data.count
        } else if collectionView == collectionMiddle {
            guard let data = BooksManager.categorizedBooks[1] else {
                return 0
            }
            return data.count
        } else {
            guard let data = BooksManager.categorizedBooks[2] else {
                return 0
            }
            return data.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    // MARK: - PDF viewer
    func viewDocument(url: URL) {
        pdfView.document = PDFDocument(url: url)
    }
    
    // MARK: - Navigation
    
    
}
