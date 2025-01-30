//
//  DBookManager.swift
//  TakeItEasy
//
//  Created by Alex Cabrera on 1/29/25.
//

import UIKit
import PDFKit

class DBookManager {

    static let searchPath = "https://www.dbooks.org/api/search/"
    static let bookPath = "https://www.dbooks.org/api/book/"

    static func searchBookList(searchString: String, update: (([DBookDetails]) -> Void)?, failure: ((Error?) -> Void)?) {

        let fixedSearchString = searchString.replacing(/\s+/, with: "+")
        let url = prepareSearchURL(searchString: fixedSearchString)
        
        guard let url else {
            failure?(nil)
            return
        }

        let completion = { (data: Data) in
            guard let jsonData = try? JSONDecoder().decode(DBooksSearchResponse.self, from: data) else {
                failure?(nil)
                return 
            }
            update?(Array(jsonData.books.prefix(20)))
        }
        fetchData(url: url, completion: completion, failure: failure)

    }

    static func fetchImage(imageURL: String, update: ((UIImage) -> Void)?, failure: ((Error?) -> Void)?) {
        let url = URL(string: imageURL)
        guard let url else {
            failure?(nil)
            return
        }

        let completion = { (data: Data) in
            let image = UIImage(data: data)
            if let image {
                update?(image)
            } else {
                failure?(nil)
            }
        }
        fetchData(url: url, completion: completion, failure: failure)
    }

    static func fetchBookURL(bookID: String, update: ((URL) -> Void)?, failure: ((Error?) -> Void)?) {
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
                let url = URL(string: jsonData.download!)
                if let url {
                    update?(url)
                } else {
                    failure?(nil)
                }
            }
        }

        fetchData(url: url, completion: completion, failure: failure)
    }

    static func prepareSearchURL(searchString: String) -> URL? {
        let textUrl = "\(searchPath)\(searchString)"
        return URL(string: textUrl)
    }

    static func prepareBookURL(bookID: String) -> URL? {
        var textUrl = "\(bookPath)\(bookID)"
        if textUrl.last == "X" {
            textUrl.removeLast()
        }
        return URL(string: textUrl)
    }

    static func fetchData(url: URL, completion: ((Data) -> Void)?, failure: ((Error?) -> Void)?) {
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

