//
//  BookListController.swift
//  TakeItEasy
//
//  Created by Alex Cabrera on 1/24/25.
//

import UIKit
import PDFKit

class BookListController: UIViewController {

    @IBOutlet weak var listSearchBar: UISearchBar!
    @IBOutlet weak var categoryTable: UITableView!

    var loadStatus: LoadStatus = .empty
    var isLoadingData = false
    var onlineCategoryList = [CategoryInfo(name: "JavaScript"), CategoryInfo(name: "Linux"), CategoryInfo(name: "Swift")]

    var offlineCategoryList = [CategoryInfo(name: "Offline", isOnline: false, bookList: [
        .init(title: "The Eclogues", author: "Virgil", image: UIImage(named: "bcover0.jpeg"), url: Bundle.main.url(forResource: "bsample0", withExtension: "pdf")),
        .init(title: "The Forerunner", author: "Khalil Gibran", image: UIImage(named: "bcover1.jpeg"), url: Bundle.main.url(forResource: "bsample1", withExtension: "pdf")),
        .init(title: "Songs of a Sourdough", author: "Robert W. Service", image: UIImage(named: "bcover2.jpeg"), url: Bundle.main.url(forResource: "bsample2", withExtension: "pdf")),
        .init(title: "Sonnets from the Portuguese", author: "Elizabeth Browning", image: UIImage(named: "bcover3.jpeg"), url: Bundle.main.url(forResource: "bsample3", withExtension: "pdf")),
    ])]

    override func viewDidLoad() {
        super.viewDidLoad()
        onlineCategoryList.append(offlineCategoryList[0])

        categoryTable.delegate = self
        categoryTable.dataSource = self
        categoryTable.allowsSelection = false

        listSearchBar.delegate = self
        listSearchBar.placeholder = "Search"
    }

    // Attempt to fetch categories from API asynchronously
    func loadAllCategories() {
        if !isLoadingData {
            isLoadingData = true
            for idx in 0..<onlineCategoryList.count {
                let category = onlineCategoryList[idx]
                guard category.isOnline else {
                    continue
                }
                let categoryIndex = IndexPath(row: idx, section: 0)
                let update = {(bookList: [DBookDetails]) in
                    self.updateCategory(bookList: bookList, categoryIndex: categoryIndex)
                }
                DBookManager.searchBookList(searchString: category.name, update: update, failure: nil)
            }
        }
    }

    // Switch status: online loads from API, offline loads books in Bundle
    func switchStatus(status: LoadStatus) {
        loadStatus = status
        reloadCategoryTable()
    }

    func reloadCategoryTable() {
        if categoryTable != nil {
            DispatchQueue.main.async {
                self.categoryTable.reloadData()
            }
        }
    }

    func reloadCategory(categoryIndex: IndexPath) {
        if categoryTable != nil {
            DispatchQueue.main.async {
                let row = self.categoryTable.cellForRow(at: categoryIndex) as? CategoryCell
                row?.booksCollection.reloadData()
            }
        }
    }

    func reloadCategoryItem(categoryIndex: IndexPath, itemIndex: IndexPath) {
        if categoryTable != nil {
            DispatchQueue.main.async {
                let row = self.categoryTable.cellForRow(at: categoryIndex) as? CategoryCell
                if row?.booksCollection.cellForItem(at: itemIndex) != nil {
                    row?.booksCollection.reloadItems(at: [itemIndex])
                }
            }
        }
    }

    // MARK: API retrieval callbakcs
    // These functions receive results from succesful API calls, and update views accordingly

    func updateBookImage(image: UIImage, book: BookInfo, categoryIndex: IndexPath, itemIndex: IndexPath) {
        book.image = image
        self.reloadCategoryItem(categoryIndex: categoryIndex, itemIndex: itemIndex)
    }

    func updateBookURL(url: URL, book: BookInfo, categoryIndex: IndexPath, itemIndex: IndexPath) {
        book.url = url
        self.reloadCategoryItem(categoryIndex: categoryIndex, itemIndex: itemIndex)
    }

    func updateCategory(bookList: [DBookDetails], categoryIndex: IndexPath) {
        let category = onlineCategoryList[categoryIndex.row]

        for (idx, dBook) in bookList.enumerated() {
            let book = BookInfo(details: dBook)
            let itemIndex = IndexPath(row: idx, section: 0)

            let imageUpdate = {(image: UIImage) in
                self.updateBookImage(image: image, book: book, categoryIndex: categoryIndex, itemIndex: itemIndex)
            }

            let urlUpdate = {(url: URL) in
                self.updateBookURL(url: url, book: book, categoryIndex: categoryIndex, itemIndex: itemIndex)
            }

            if dBook.image != nil {
                DBookManager.fetchImage(imageURL: dBook.image!, update: imageUpdate, failure: nil)
            }
            if dBook.id != nil {
                DBookManager.fetchBookURL(bookID: dBook.id!, update: urlUpdate, failure: nil)
            }

            category.bookList.append(book)
            self.switchStatus(status: .online)
            self.reloadCategory(categoryIndex: categoryIndex)
        }
    }

}

extension BookListController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch loadStatus {
            case .empty:
                return 0
            case .online:
                return onlineCategoryList.count
            case .offline:
                return offlineCategoryList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        if loadStatus == .empty {
            return cell
        }

        let currentCategory = if loadStatus == .online {
            onlineCategoryList[indexPath.row]
        } else {
            offlineCategoryList[indexPath.row]
        }

        cell.categoryLabel.text = currentCategory.name

        // Each table row represents a category, sets up associated collection of books
        cell.booksCollection.delegate = self
        cell.booksCollection.dataSource = self
        cell.booksCollection.categoryIndex = indexPath.row
        cell.booksCollection.reloadData()

        return cell
    }
}

extension BookListController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        guard let booksCollection = collectionView as? BooksCollection else {
            return 0
        }

        guard let categoryIndex = booksCollection.categoryIndex else {
            return 0
        }

        switch loadStatus {
            case .empty:
                return 0
            case .online:
                return onlineCategoryList[categoryIndex].bookList.count
            case .offline:
                return offlineCategoryList[categoryIndex].bookList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCell

        guard let booksCollection = collectionView as? BooksCollection else {
            return cell
        }

        guard let categoryIndex = booksCollection.categoryIndex else {
            return cell
        }

        if loadStatus == .empty {
            return cell
        }

        let currentBook = if loadStatus == .online {
            onlineCategoryList[categoryIndex].bookList[indexPath.row]
        } else {
            offlineCategoryList[categoryIndex].bookList[indexPath.row]
        }

        cell.backView.backgroundColor = ThemeManager.backColor
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

        cell.titleLabel.text = currentBook.title
        cell.authorLabel.text = currentBook.author
        cell.imageHolder.image = currentBook.image
        cell.imageHolder.contentMode = .scaleAspectFit

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let booksCollection = collectionView as? BooksCollection else {
            return
        }

        guard let categoryIndex = booksCollection.categoryIndex else {
            return
        }

        if loadStatus == .empty {
            return
        }

        let currentBook = loadStatus == .online ? onlineCategoryList[categoryIndex].bookList[indexPath.row] : offlineCategoryList[categoryIndex].bookList[indexPath.row]

        // Transition to PDF reader in separate screen
        let bookSB = UIStoryboard(name: "BookStoryboard", bundle: nil)
        let pdfController = bookSB.instantiateViewController(identifier: "BookReaderController") as! BookReaderController
        pdfController.selectedBook = currentBook
        self.navigationController?.pushViewController(pdfController, animated: true)
    }

}

extension BookListController: UISearchBarDelegate {

    // On user interaction with search bar, move to separate search/result screen
    // Note: May trigger text entry on current search bar, still needs to be disabled somehow.
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

        let bookSB = UIStoryboard(name: "BookStoryboard", bundle: nil)
        let resultController = bookSB.instantiateViewController(identifier: "BookSearchController")
        self.navigationController?.pushViewController(resultController, animated: true)

    }
}

class CategoryCell: UITableViewCell {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var booksCollection: BooksCollection!
}

class BookCell: UICollectionViewCell {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var imageHolder: UIImageView!
}

class BooksCollection: UICollectionView {
    var categoryIndex: Int?
}
