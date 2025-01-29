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

        DispatchQueue.main.async {
            self.navigationItem.searchController?.searchBar.becomeFirstResponder()
        }
    }

    func reloadData() {
        DispatchQueue.main.async {
            self.resultCollection.reloadData()
        }
    }

    func reloadItem(itemIndex: IndexPath) {
        DispatchQueue.main.async {
            let cell = self.resultCollection.cellForItem(at: itemIndex)
            if cell != nil {
                self.resultCollection.reloadItems(at: [itemIndex])
            }
        }
    }

    func updateBookURL(url: URL, book: BookInfo, itemIndex: IndexPath) {
        book.url = url
        reloadItem(itemIndex: itemIndex)
    }

    func updateBookImage(image: UIImage, book: BookInfo, itemIndex: IndexPath) {
        book.image = image
        reloadItem(itemIndex: itemIndex)
    }

    func updateBooks(bookList: [DBookDetails]) {
        for (idx, dBook) in bookList.enumerated() {
            let book = BookInfo(details: dBook)
            let itemIndex = IndexPath(row: idx, section: 0)

            let imageUpdate = {(image: UIImage) in
                self.updateBookImage(image: image, book: book, itemIndex: itemIndex)
            }

            let urlUpdate = {(url: URL) in
                self.updateBookURL(url: url, book: book, itemIndex: itemIndex)
            }

            if dBook.image != nil {
                DBookManager.fetchImage(imageURL: dBook.image!, update: imageUpdate, failure: nil)
            }
            if dBook.id != nil {
                DBookManager.fetchBookURL(bookID: dBook.id!, update: urlUpdate, failure: nil)
            }

            self.bookList.append(book)
            self.reloadData()
        }
    }
}

extension BookResultsController: UISearchResultsUpdating, UISearchBarDelegate {

    func updateSearchResults(for searchController: UISearchController) {
        searchTimer?.invalidate()

        searchTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.bookList = []
            if searchController.searchBar.text != nil && searchController.searchBar.text!.count > 0 {
                DBookManager.searchBookList(searchString: searchController.searchBar.text!, update: self.updateBooks, failure: nil)
            } else {
                self.reloadData()
            }
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
