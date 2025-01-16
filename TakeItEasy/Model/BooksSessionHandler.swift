//
//  BooksSessionHandler.swift
//  TakeItEasy
//
//  Created by Carlos Quinto on 1/16/25.
//

import Foundation

let apiUrl = URL(filePath: "https://www.dbooks.org/api/")

/*
func booksDataFetchCompletion(completionHandler: @escaping ([StoredBook]) -> Void) {
    var booksDataFetched: [StoredBook]
    
    let task = URLSession.shared.dataTask(with: apiUrl, completionHandler: ({ data, response, error in
        if let error = error {
            print("Error retrieving data from {\(apiUrl.lastPathComponent)} : \(error)")
            return
        }
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            print("Error retrieving data from {\(apiUrl.lastPathComponent)} source: \(response)")
        }
        
        if let data = data {
            let booksDecoded = try? JSONDecoder().decode(StoredBook, from: data) {
                completionHandler(booksDecoded.results ?? [])
            }
        }
         
    })
    
    task.resume()
    
    completionHandler(booksDataFetched)
}
*/
