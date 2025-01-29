//
//  BookResultsController.swift
//  TakeItEasy
//
//  Created by Alex Cabrera on 1/27/25.
//

import UIKit

class BookResultsController: UIViewController {

    var bookList = [BookInfo]()
    @IBOutlet weak var resultCollection: UICollectionView!
    var searchTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        searchController.searchBar.searchTextField.backgroundColor = ThemeManager.lightTheme.secondaryColor

        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        resultCollection.delegate = self
        resultCollection.dataSource = self

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Delay slightly to ensure the search bar is ready
        DispatchQueue.main.async {
            self.navigationItem.searchController?.searchBar.becomeFirstResponder()
        }
    }

    func reloadData() {
        DispatchQueue.main.async {
            self.resultCollection.reloadData()
        }
    }

    func reloadItem(indexPath: IndexPath) {
        self.resultCollection.reloadItems(at: [indexPath])
    }

    func searchAndUpdateBooks(searchString: String) {
        let url = prepareSearchURL(searchString: searchString)
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
                let indexPath = IndexPath(row: idx, section: 0)
                if dBook.image != nil {
                    self.fetchBookImage(imageURL: dBook.image!, book: book, indexPath: indexPath)
                }
                if dBook.id != nil {
                    self.fetchBookURL(bookID: dBook.id!, book: book, indexPath: indexPath)
                }
                self.bookList.append(book)
                self.reloadData()
            }
        }

        let failure = { (error: Error?) in
            print("Search failure")
            if error != nil {
                print(error!)
            }
        }

        fetchData(url: url, completion: completion, failure: failure)
    }

    func fetchBookImage(imageURL: String, book: BookInfo, indexPath: IndexPath) {
        let url = URL(string: imageURL)
        guard let url else {
            print("Invalid image url")
            return
        }

        let completion = { (data: Data) in
            book.image = UIImage(data: data)

            DispatchQueue.main.async {
                let cell = self.resultCollection.cellForItem(at: indexPath)
                if cell != nil {
                    self.reloadItem(indexPath: indexPath)
                }
            }
        }

        let failure = { (error: Error?) in
            print("Image retrieval failure")
            if error != nil {
                print(error!)
            }
        }

        fetchData(url: url, completion: completion, failure: failure)
    }

    func fetchBookURL(bookID: String, book: BookInfo, indexPath: IndexPath) {
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

            DispatchQueue.main.async {
                let cell = self.resultCollection.cellForItem(at: indexPath)
                if cell != nil {
                    self.reloadItem(indexPath: indexPath)
                }
            }
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
        print(textUrl)
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

extension BookResultsController: UISearchResultsUpdating, UISearchBarDelegate {

    func updateSearchResults(for searchController: UISearchController) {
        searchTimer?.invalidate()

        if searchController.searchBar.text != nil && searchController.searchBar.text!.count > 0 {
            searchTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.bookList = []
                self.searchAndUpdateBooks(searchString: searchController.searchBar.text!)
            }
        } else {
            self.bookList = []
            reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension BookResultsController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookResultCell", for: indexPath)
        guard let resultCell = cell as? BookResultCell else {
            return cell
        }

        resultCell.backView.backgroundColor = ThemeManager.lightTheme.backColor
        resultCell.backView.layer.borderColor = UIColor.systemBackground.cgColor
        resultCell.backView.layer.borderWidth = 0.2

        resultCell.backView.layer.cornerRadius = 18.0
        resultCell.backView.layer.masksToBounds = false

        resultCell.backView.layer.shadowColor = UIColor.black.cgColor
        resultCell.backView.layer.shadowOpacity = 0.5
        resultCell.backView.layer.shadowOffset = CGSize(width: 4, height: 4)
        resultCell.backView.layer.shadowRadius = 4

        resultCell.backView.layer.shadowPath = UIBezierPath(
            roundedRect: resultCell.backView.bounds,
            cornerRadius: resultCell.backView.layer.cornerRadius
        ).cgPath

        let book = bookList[indexPath.row]
        resultCell.imageHolder.image = book.image
        resultCell.titleLabel.text = book.title
        resultCell.authorLabel.text = book.author
        return resultCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let currentBook = bookList[indexPath.row]
        let bookSB = UIStoryboard(name: "BookStoryboard", bundle: nil)
        let pdfController = bookSB.instantiateViewController(identifier: "PDFViewController") as! PDFViewController
        pdfController.selectedBook = currentBook
        self.navigationController?.pushViewController(pdfController, animated: true)
    }

}

class BookResultCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imageHolder: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
}
