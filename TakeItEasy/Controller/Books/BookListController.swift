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

    var onlineCategoryList = [CategoryInfo(name: "JavaScript"), CategoryInfo(name: "Linux"), CategoryInfo(name: "Swift")]

    var offlineCategoryList = [CategoryInfo(name: "Offline", isOnline: false, bookList: [
        .init(title: "The Eclogues", author: "Virgil", image: UIImage(named: "bcover0.jpeg"), url: Bundle.main.url(forResource: "bsample0", withExtension: "pdf")),
        .init(title: "The Forerunner", author: "Khalil Gibran", image: UIImage(named: "bcover1.jpeg"), url: Bundle.main.url(forResource: "bsample1", withExtension: "pdf")),
        .init(title: "Songs of a Sourdough", author: "Robert W. Service", image: UIImage(named: "bcover2.jpeg"), url: Bundle.main.url(forResource: "bsample2", withExtension: "pdf")),
        .init(title: "Sonnets from the Portuguese", author: "Elizabeth Browning", image: UIImage(named: "bcover3.jpeg"), url: Bundle.main.url(forResource: "bsample3", withExtension: "pdf")),
    ])]

    func reloadCollection(status: LoadStatus) {
        loadStatus = status
        DispatchQueue.main.async {
            self.categoryTable.reloadData()
        }
    }

    func fetchCategoryData(categoryIndex: Int, completion: (() -> Void)?) {
        let category = onlineCategoryList[categoryIndex]
        let textUrl = "https://www.dbooks.org/api/search/\(category.name.lowercased())"
        guard let url = URL(string: textUrl) else {
            return
        }

        // Retrieve book list
        self.fetchData(url: url) { data, error in

            // Switch to offline mode on failure
            if error != nil {
                self.reloadCollection(status: .offline)
                return
            }

            guard let data else {
                self.reloadCollection(status: .offline)
                return
            }

            guard let jsonData = try? JSONDecoder().decode(DBooksSearchResponse.self, from: data) else {
                print("Unexpected json format")
                print(textUrl)
                return
            }

            let limitedBooks = jsonData.books.prefix(20)

            // Populate books array with fetched books
            for dBook in limitedBooks {
                category.bookList.append(BookInfo(details: dBook))
            }
            self.reloadCollection(status: .online)

            for (idx, dBook) in limitedBooks.enumerated() {
                self.retrieveImage(dBook: dBook, categoryIndex: categoryIndex, bookIndex: idx)
                self.retrieveUrl(dBook: dBook, categoryIndex: categoryIndex, bookIndex: idx)
            }

            completion?()
        }
    }

    func retrieveImage(dBook: DBookDetails, categoryIndex: Int, bookIndex: Int) {


        let category = onlineCategoryList[categoryIndex]
        guard let textUrl = dBook.image, let url = URL(string: textUrl) else {
            return
        }

        // Retrieve images for each book
        self.fetchData(url: url) { data, error in

            if error != nil {
                return
            }

            guard let data else {
                return
            }

            category.bookList[bookIndex].image = UIImage(data: data)

            let categoryIndexPath = IndexPath(row: categoryIndex, section: 0)
            let bookIndexPath = IndexPath(row: bookIndex, section: 0)

            DispatchQueue.main.async {
                guard let categoryRow = self.categoryTable.cellForRow(at: categoryIndexPath) as? CategoryCell else {
                    return
                }
                categoryRow.booksCollection.reloadItems(at: [bookIndexPath])
            }
        }

    }

    func retrieveUrl(dBook: DBookDetails, categoryIndex: Int, bookIndex: Int) {

        let category = onlineCategoryList[categoryIndex]
        guard dBook.id != nil else {
            return
        }

        var textUrl = "https://www.dbooks.org/api/book/\(dBook.id!)"
        if textUrl.last == "X" {
            textUrl.removeLast()
        }

        guard let url = URL(string: textUrl) else {
            return
        }

        // Retrieve further detalis for each book
        self.fetchData(url: url) { data, error in

            if error != nil {
                return
            }

            guard let data else {
                return
            }

            guard let jsonData = try? JSONDecoder().decode(DBookDetails.self, from: data) else {
                print("Unexpected json format")
                print(textUrl)
                return
            }

            guard jsonData.download != nil else {
                return
            }
            category.bookList[bookIndex].url = URL(string: jsonData.download!)
        }

    }

    func fetchData(url: URL, completion: @escaping (Data?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.timeoutInterval = 5.0

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(data, error)
        }
        task.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTable.delegate = self
        categoryTable.dataSource = self
        categoryTable.allowsSelection = false

        listSearchBar.delegate = self
        listSearchBar.placeholder = "Search"

        for idx in 0..<onlineCategoryList.count {
            self.fetchCategoryData(categoryIndex: idx, completion: nil)
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
