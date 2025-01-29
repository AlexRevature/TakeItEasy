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
        categoryTable.delegate = self
        categoryTable.dataSource = self
        categoryTable.allowsSelection = false

        listSearchBar.delegate = self
        listSearchBar.placeholder = "Search"

        loadAllCategories()
    }

    func loadAllCategories() {
        if !isLoadingData {
            isLoadingData = true
            for idx in 0..<onlineCategoryList.count {
                self.updateCategoryData(categoryIndex: idx, completion: nil)
            }
        }
    }

    func reloadCollection(status: LoadStatus) {
        loadStatus = status
        if categoryTable != nil {
            DispatchQueue.main.async {
                self.categoryTable.reloadData()
            }
        }
    }

    func reloadCollectionItem(categoryPath: IndexPath, itemPath: IndexPath) {
        if categoryTable != nil {
            DispatchQueue.main.async {
                let row = self.categoryTable.cellForRow(at: categoryPath) as? CategoryCell
                if let row {
                    let cell = row.booksCollection.cellForItem(at: itemPath)
                    if cell != nil {
                        row.booksCollection.reloadItems(at: [itemPath])
                    }
                }
            }
        }
    }

    func updateCategoryData(categoryIndex: Int, completion: (() -> Void)?) {
        let category = onlineCategoryList[categoryIndex]
        let categoryPath = IndexPath(row: categoryIndex, section: 0)
        let url = prepareSearchURL(searchString: category.name.lowercased())

        guard let url else {
            print("Invalid search url")
            return
        }

        let completion = { (data: Data) in
            guard let jsonData = try? JSONDecoder().decode(DBooksSearchResponse.self, from: data) else {
                print("Unexpected json format")
                return
            }
            let limitedBooks = jsonData.books.prefix(20)

            for (idx, dBook) in limitedBooks.enumerated() {
                let book = BookInfo(details: dBook)
                let itemPath = IndexPath(row: idx, section: 0)
                if dBook.image != nil {
                    self.fetchBookImage(imageURL: dBook.image!, book: book, categoryPath: categoryPath, itemPath: itemPath)
                }
                if dBook.id != nil {
                    self.fetchBookURL(bookID: dBook.id!, book: book, categoryPath: categoryPath, itemPath: itemPath)
                }
                category.bookList.append(book)
                self.reloadCollection(status: .online)
            }
        }

        let failure = { (error: Error?) in
            print("Image retrieval failure")
            if error != nil {
                print(error!)
            }
            self.reloadCollection(status: .offline)
        }

        fetchData(url: url, completion: completion, failure: failure)
    }

    func fetchBookImage(imageURL: String, book: BookInfo, categoryPath: IndexPath, itemPath: IndexPath) {

        let url = URL(string: imageURL)
        guard let url else {
            print("Invalid image url")
            return
        }

        let completion = { (data: Data) in
            book.image = UIImage(data: data)

            self.reloadCollectionItem(categoryPath: categoryPath, itemPath: itemPath)
        }

        let failure = { (error: Error?) in
            print("Image retrieval failure")
            if error != nil {
                print(error!)
            }
        }

        fetchData(url: url, completion: completion, failure: failure)
    }

    func fetchBookURL(bookID: String, book: BookInfo, categoryPath: IndexPath, itemPath: IndexPath) {
        let url = prepareBookURL(bookID: bookID)
        guard let url else {
            print("Invalid book url")
            return
        }

        let completion = { (data: Data) in
            guard let jsonData = try? JSONDecoder().decode(DBookDetails.self, from: data) else {
                print("Unexpected json format")
                return
            }
            if jsonData.download != nil {
                book.url = URL(string: jsonData.download!)
            }

            self.reloadCollectionItem(categoryPath: categoryPath, itemPath: itemPath)
        }

        let failure = { (error: Error?) in
            print("Book url retrieval failure")
            if error != nil {
                print(error!)
            }
        }

        fetchData(url: url, completion: completion, failure: failure)
    }

    func prepareSearchURL(searchString: String) -> URL? {
        let textUrl = "https://www.dbooks.org/api/search/\(searchString)"
        return URL(string: textUrl)
    }

    func prepareBookURL(bookID: String) -> URL? {
        var textUrl = "https://www.dbooks.org/api/book/\(bookID)"
        if textUrl.last == "X" {
            textUrl.removeLast()
        }
        return URL(string: textUrl)
    }

    func fetchData(url: URL, completion: ((Data) -> Void)?, failure: ((Error?) -> Void)?) {
        var request = URLRequest(url: url)
        request.timeoutInterval = 5.0

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data, error == nil else {
                failure?(error)
                return
            }
            completion?(data)
        }
        task.resume()
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

        let currentCategory = loadStatus == .online ? onlineCategoryList[indexPath.row] : offlineCategoryList[indexPath.row]

        cell.categoryLabel.text = currentCategory.name

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

        let currentBook = loadStatus == .online ? onlineCategoryList[categoryIndex].bookList[indexPath.row] : offlineCategoryList[categoryIndex].bookList[indexPath.row]

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

        cell.titleLabel.text = currentBook.title
        cell.authorLabel.text = currentBook.author
        cell.imageHolder.image = currentBook.image
        cell.imageHolder.contentMode = .scaleAspectFit
//        cell.imageHolder.backgroundColor = UIColor.gray

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

        let bookSB = UIStoryboard(name: "BookStoryboard", bundle: nil)
        let pdfController = bookSB.instantiateViewController(identifier: "PDFViewController") as! PDFViewController
        pdfController.selectedBook = currentBook
        self.navigationController?.pushViewController(pdfController, animated: true)
    }

}

extension BookListController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

        let bookSB = UIStoryboard(name: "BookStoryboard", bundle: nil)
        let resultController = bookSB.instantiateViewController(identifier: "BookResultsController")
        self.navigationController?.pushViewController(resultController, animated: true)

    }
}

class BookInfo {
    var title: String
    var author: String
    var image: UIImage?
    var url: URL?
    var document: PDFDocument?

    init(title: String, author: String, image: UIImage? = nil, url: URL? = nil) {
        self.title = title
        self.author = author
        self.image = image
        self.url = url
    }

    init(details: DBookDetails) {
        self.title = details.title ?? ""
        self.author = details.authors ?? ""
    }
}


class CategoryInfo {
    var name: String
    var isOnline: Bool
    var bookList: [BookInfo]

    init(name: String, isOnline: Bool = true, bookList: [BookInfo] = [BookInfo]()) {
        self.name = name
        self.isOnline = isOnline
        self.bookList = bookList
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

class DBooksSearchResponse: Decodable {
    let status: String
    let books: [DBookDetails]
}

class DBookDetails: Decodable {
    let id: String?
    let title: String?
    let subtitle: String?
    let authors: String?
    let image: String?
    var download: String?
}

enum LoadStatus {
    case online
    case offline
    case empty
}
