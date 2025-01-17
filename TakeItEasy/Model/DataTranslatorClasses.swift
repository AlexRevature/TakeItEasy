//
//  DataTranslatorClasses.swift
//  TakeItEasy
//
//  Created by admin on 1/16/25.
//

import Foundation

class Book {
    var name: String = ""
    var authorNameLast: String = ""
    var authorNameFirst: String = ""
    var category: String = ""
    var releaseDate: Date = Date.now
    var coverImage: Data = Data()
    var fileData: Data = Data()
    
    init(name: String, authorNameLast: String, authorNameFirst: String, category: String, releaseDate: Date, coverImage: Data, fileData: Data) {
        self.name = name
        self.authorNameLast = authorNameLast
        self.authorNameFirst = authorNameFirst
        self.category = category
        self.releaseDate = releaseDate
        self.coverImage = coverImage
        self.fileData = fileData
    }
    
    init () {}
}
