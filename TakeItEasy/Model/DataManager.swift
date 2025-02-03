//
//  DataManager.swift
//  TakeItEasy
//
//  Created by Alex Cabrera on 1/30/25.
//

import Foundation

class DataManager {

    static var formatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()

    static let quizList: [QuizInfo] = [
        .init(name: "Swift Language", author: "John Apple", date: formatter.date(from: "2025/1/10")!, imageName: "swift", questionList: [
            .init(text: "How would you force unwrap the optional variable 'tmp'?", value: 50, correctIndex: 0, options: [
                "tmp!",
                "tmp?",
                "!tmp",
                "tmp ?? nil",
                "tmp -> nTmp"
            ]),
            .init(text: "What keyword/symbol is used in a closure after listing its arguments?", value: 60, correctIndex: 3, options: [
                "perform",
                "do",
                "->",
                "in",
                "action"
            ]),
            .init(text: "What is the 'some' keyword used for?", value: 90, correctIndex: 2, options: [
                "closures",
                "reference types",
                "opaque types",
                "ForLoop callback",
                "H-O value dereferencing"
            ]),
            .init(text: "Who created the Swift language?", value: 10, correctIndex: 4, options: [
                "Bobby Tables",
                "John Swift",
                "Graydon Hoare",
                "John Closure",
                "Chris Lattner"
            ]),
            .init(text: "Which of these is not a feature of the language?", value: 120, correctIndex: 0, options: [
                "Garbage Collection",
                "Closures",
                "Reference Counting",
                "Extensions",
                "Protocols"
            ])
        ]),
        .init(name: "UIKit Features", author: "Johnathan Apple", date: formatter.date(from: "2025/1/15")!, imageName: "wand.and.sparkles", questionList: [
            .init(text: "How do you navigate to a new viewController when using a Navigation Controller?", value: 50, correctIndex: 0, options: [
                "nav.pushViewController(vc)",
                "nav.present(vc)",
                "present(vc)",
                "nav.viewTransition(vc)",
                "addToQueue(vc)"
            ]),
            .init(text: "Which is not a valid core data entity attribute type?", value: 60, correctIndex: 1, options: [
                "String",
                "Int",
                "Date",
                "Boolean",
                "Float"
            ]),
            .init(text: "Which transition callback doesn't exist?", value: 80, correctIndex: 3, options: [
                "viewWillTransition",
                "viewIsAppearing",
                "viewDidLayoutSubviews",
                "viewWillSetMargins",
                "viewDidDisappear"
            ]),
            .init(text: "Which of these are properties of the main task in the GCD?", value: 150, correctIndex: 2, options: [
                "serial and async",
                "concurrent and sync",
                "serial and sync",
                "concurrent and async",
                "N/A"
            ]),
            .init(text: "To what iOS layer does AVFoundation belong to?", value: 40, correctIndex: 2, options: [
                "Core OS",
                "Core Services",
                "Media",
                "Cocoa Touch",
                "N/A"
            ])
        ]),
        .init(name: "Design Patterns", author: "Joe Apple", date: formatter.date(from: "2025/1/16")!, imageName: "pencil", questionList: [
            .init(text: "Which of these is not a SOLID principle?", value: 80, correctIndex: 4, options: [
                "Dependency Inversion",
                "Lizkov Substitution",
                "Interface Segregation",
                "Single Responsibility",
                "Order First"
            ]),
            .init(text: "What design does the Elm framework use?", value: 60, correctIndex: 2, options: [
                "Model-View-Controller",
                "Model-View-Presenter",
                "Model-View-Update",
                "Model-View-ViewModel",
                "Presentation-Abstraction"
            ]),
            .init(text: "What does KVO stand for?", value: 40, correctIndex: 0, options: [
                "Key Value Observation",
                "Known Vector Organizer",
                "Key Value Operation",
                "Known Variable Optimization",
                "Kind Variable Operation"
            ]),
            .init(text: "What keyword-pair is necessary to (generally) create a singleton?", value: 100, correctIndex: 3, options: [
                "static func",
                "some func",
                "final struct",
                "static var/let",
                "some var/let"
            ]),
            .init(text: "Which of these is not a delegate protocol in Swift?", value: 120, correctIndex: 1, options: [
                "UITableViewDelegate",
                "UILocationDelegate",
                "AVAudioPlayerDelegate",
                "WKNavigationDelegate",
                "UICollectionViewDelegate"
            ])
        ]),
        .init(name: "Potpourri", author: "George Apple", date: formatter.date(from: "2025/1/17")!, imageName: "carrot", questionList: [
            .init(text: "What is the key difference between MVC and MVVM?", value: 50, correctIndex: 0, options: [
                "Data binding",
                "Location services",
                "Model structure",
                "Protocol permissions",
                "N/A"
            ]),
            .init(text: "Which of these is persisted after an app is deleted?", value: 60, correctIndex: 1, options: [
                "CoreData objects",
                "Keychain entries",
                "UserDefault values",
                "'opaque' arrays",
                "SceneDelegate variables"
            ]),
            .init(text: "Which of these is not a package manager for Swift dependencies?", value: 90, correctIndex: 3, options: [
                "Swift pm",
                "CocoaPods",
                "Accio",
                "Homebrew",
                "Carthage"
            ]),
            .init(text: "Where are swift primitive types (Int/Double/etc) provided?", value: 90, correctIndex: 1, options: [
                "Core Swift language",
                "Swift Standard Library",
                "CoreFoundation",
                "Swift Foundation",
                "N/A"
            ]),
            .init(text: "For which of these can you NOT use 'extension'?", value: 120, correctIndex: 0, options: [
                "func",
                "class",
                "struct",
                "enum",
                "protocol"
            ])
        ]),
        .init(name: "Trivia", author: "Gregory Apple", date: formatter.date(from: "2025/1/20")!, imageName: "newspaper", questionList: [
            .init(text: "What is the world population as of January 2025", value: 50, correctIndex: 0, options: [
                "8.2 billion",
                "7.9 billion",
                "8.1 billion",
                "7.2 billion",
                "7.8 billion"
            ]),
            .init(text: "What's the real name of the xkcd creator?", value: 70, correctIndex: 1, options: [
                "Jacob Geller",
                "Randall Munroe",
                "Joseph Keppler",
                "Amy Hwang",
                "Jim Davis"
            ]),
            .init(text: "How many of the top ten highest grossing films (Jan 2025) aren't part of a franchise, or a remake?", value: 40, correctIndex: 4, options: [
                "0",
                "4",
                "None",
                "6",
                "1"
            ]),
            .init(text: "Can a match box?", value: 90, correctIndex: 2, options: [
                "Yes",
                "No",
                "No, but a tin can",
                "Yes, one beat Mike Tyson",
                "+500 points"
            ]),
            .init(text: "What is the capital of Kazakhstan?", value: 500, correctIndex: 3, options: [
                "Dushanbe",
                "Ashgabat",
                "Tashkent",
                "Astana",
                "Bishkek"
            ])
        ])
    ]
}

