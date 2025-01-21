//
//  ControllerManager.swift
//  TakeItEasy
//
//  Created by Alex Cabrera on 1/16/25.
//

import UIKit

class ControllerManager {

    static func mainTransition(navigationController: UINavigationController?) {

        let bookSB = UIStoryboard(name: "BooksStoryboard", bundle: nil)
        let booksController = bookSB.instantiateViewController(identifier: "InitialScene")

        let quizSB = UIStoryboard(name: "QuizzesStoryboard", bundle: nil)
        let quizzesController = quizSB.instantiateViewController(identifier: "QuizListController")

        let notesSB = UIStoryboard(name: "NotesStoryboard", bundle: nil)
        let notesController = notesSB.instantiateViewController(identifier: "NotesViewController")

        let webSB = UIStoryboard(name: "WebViewStoryboard", bundle: nil)
        let webController = webSB.instantiateViewController(identifier: "InitialScene")

        booksController.tabBarItem = UITabBarItem(title: "Books", image: UIImage(systemName: "book"), tag: 0)
        quizzesController.tabBarItem = UITabBarItem(title: "Quizs", image: UIImage(systemName: "bubble.and.pencil"), tag: 1)
        notesController.tabBarItem = UITabBarItem(title: "Notes", image: UIImage(systemName: "note.text"), tag: 2)
        webController.tabBarItem = UITabBarItem(title: "Web", image: UIImage(systemName: "network"), tag: 3)

        let tabController = UITabBarController()
        tabController.viewControllers = [quizzesController, notesController, booksController, webController]

        tabController.tabBar.unselectedItemTintColor = UIColor.lightGray
        tabController.tabBar.tintColor = UIColor.white
        tabController.tabBar.backgroundColor = ThemeManager.lightTheme.primaryColor

        navigationController?.delegate = NavigationDelegate.shared
        navigationController?.setViewControllers([tabController], animated: true)
    }
}

class NavigationDelegate: NSObject, UINavigationControllerDelegate {

    static let shared = NavigationDelegate()
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

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {

        if (navigationController.topViewController as? UITabBarController) != nil {
            viewController.navigationItem.rightBarButtonItem = barButtonItem
            viewController.navigationItem.title = UserManager.currentUser?.username ?? ""
        }
    }
}
