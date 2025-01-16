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
    }
    
    // MARK: - CollectionView functions
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellItem", for: indexPath) as! BooksCollectionViewCell
        
        if BooksManager.storedBooks.count > 0 {
            guard let coverImage = BooksManager.storedBooks[indexPath.row].coverImage else {
                cell.bookCoverImage.image = UIImage(systemName: "book")
                return cell
            }
            cell.bookCoverImage.image = UIImage(data: coverImage)
            return cell
        } else {
            cell.bookCoverImage.isHidden = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if BooksManager.storedBooks.count > 0 {
            return collectionSectionLimit
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfSections section: Int, indexPath: IndexPath) -> Int {
        if BooksManager.storedBooks.count > 0 {
            return collectionSectionsCount()
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if BooksManager.storedBooks.count > 0 {
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerItem", for: indexPath) as! BooksCollectionReusableView
                
                sections[indexPath.section] = BooksManager.storedBooks[indexPath.row].category
                header.sectionIndex = indexPath.section
                
                guard let sectionName = sections[indexPath.section] else {
                    header.sectionName.text = "Uncategorized"
                    return header
                }
                header.sectionName.text = sectionName
                return header
            default:
                assert(false, "Invalid element")
            }
        } else {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerItem", for: indexPath) as! BooksCollectionReusableView
            
            header.sectionName.text = stringEmptyDataContainer
            return header
        }
    }
    
    func collectionSectionsCount() -> Int {
        var sectionsTotal = 0
        let sectionNames = sections.values
        
        for book in BooksManager.storedBooks {
            if !sectionNames.contains(where: { $0 == book.category }) {
                sectionsTotal += 1
            }
        }
        return sectionsTotal
    }
    
    // MARK: - PDF viewer
    func viewDocument(url: URL) {
        pdfView.document = PDFDocument(url: url)
    }
    
    // MARK: - Navigation
    
    
}
