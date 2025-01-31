//
//  ControllerManager.swift
//  TakeItEasy
//
//  Created by Alex Cabrera on 1/16/25.
//

import UIKit

class ControllerManager {

    static let booksController = {
        let bookSB = UIStoryboard(name: "BookStoryboard", bundle: nil)
        let booksController = bookSB.instantiateViewController(identifier: "BookListController") as! BookListController
        booksController.loadAllCategories()
        return booksController
    }()

    static let quizzesController = {
        let quizSB = UIStoryboard(name: "QuizzesStoryboard", bundle: nil)
        return quizSB.instantiateViewController(identifier: "QuizListController")
    }()

    static let notesController = {
        let notesSB = UIStoryboard(name: "NotesStoryboard", bundle: nil)
        return notesSB.instantiateViewController(identifier: "NotesViewController")
    }()

    static let webController = {
        let webSB = UIStoryboard(name: "WebViewStoryboard", bundle: nil)
        let webController = webSB.instantiateViewController(identifier: "WebViewController") as! WebViewController
        webController.setUpWebView()
        return webController
    }()

    static func mainTransition(navigationController: UINavigationController?) {

        booksController.tabBarItem = UITabBarItem(title: "Books", image: UIImage(systemName: "book"), tag: 0)
        quizzesController.tabBarItem = UITabBarItem(title: "Quizzes", image: UIImage(systemName: "bubble.and.pencil"), tag: 1)
        notesController.tabBarItem = UITabBarItem(title: "Notes", image: UIImage(systemName: "note.text"), tag: 2)
        webController.tabBarItem = UITabBarItem(title: "Web", image: UIImage(systemName: "network"), tag: 3)

        let tabController = UITabBarController()
        tabController.viewControllers = [quizzesController, notesController, booksController, webController]

        let tabAppearance = UITabBarAppearance()
        tabAppearance.backgroundColor = ThemeManager.primaryColor

        tabAppearance.stackedLayoutAppearance.selected.iconColor = UIColor.white
        tabAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        tabAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.lightGray
        tabAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]

        tabController.tabBar.standardAppearance = tabAppearance
        tabController.tabBar.scrollEdgeAppearance = tabAppearance

        let barButtonItem: UIBarButtonItem? = {

            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = scene.delegate as? SceneDelegate else {
                return nil
            }

            return UIBarButtonItem (
                title: "Log Out",
                style: .done,
                target: sceneDelegate,
                action: #selector(sceneDelegate.logOut)
            )
        }()

        tabController.navigationItem.backButtonTitle = "Back"
        tabController.navigationItem.rightBarButtonItem = barButtonItem
        tabController.navigationItem.title = "\(UserManager.currentUser?.username ?? "")"

        navigationController?.setViewControllers([tabController], animated: true)
    }
}
