//
//  ControllerManager.swift
//  TakeItEasy
//
//  Created by Alex Cabrera on 1/16/25.
//

import UIKit

class ControllerManager {

    // Makes a tabBar the root of the navBar, with all relevant screens connected.
    static func mainTransition(navigationController: UINavigationController?) {

        let bookSB = UIStoryboard(name: "BookStoryboard", bundle: nil)
        let booksController = bookSB.instantiateViewController(identifier: "BookListController") as! BookListController
        booksController.loadAllCategories()

        let quizSB = UIStoryboard(name: "QuizStoryboard", bundle: nil)
        let quizzesController = quizSB.instantiateViewController(identifier: "QuizListController")

        let notesSB = UIStoryboard(name: "NotesStoryboard", bundle: nil)
        let notesController = notesSB.instantiateViewController(identifier: "NotesViewController")

        let webSB = UIStoryboard(name: "WebViewStoryboard", bundle: nil)
        let webController = webSB.instantiateViewController(identifier: "WebViewController") as! WebViewController
        webController.setUpWebView()

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

        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = scene.delegate as? SceneDelegate else {
            return
        }

        let rightBarButtonItem: UIBarButtonItem? = {

            return UIBarButtonItem (
                title: "Log Out",
                style: .done,
                target: sceneDelegate,
                action: #selector(sceneDelegate.logOut)
            )
        }()

        let middleButton = UIButton(type: .system)
        if let username = UserManager.currentUser?.username {
            middleButton.setTitle(" \(username.capitalized) ", for: .normal)
        }
        middleButton.addTarget(sceneDelegate, action: #selector(sceneDelegate.showUser), for: .touchUpInside)
        middleButton.titleLabel?.font = UIFont(name: "Courier New Bold", size: 18) ?? UIFont.italicSystemFont(ofSize: 18)
        middleButton.backgroundColor = ThemeManager.secondaryColor
        middleButton.layer.cornerRadius = 7
        middleButton.clipsToBounds = true

        // Note: Shared for all direct children views of the tabBar, since only the tabBar
        // is really directly connected to the navigation controller.
        tabController.navigationItem.backButtonTitle = "Back"
        tabController.navigationItem.rightBarButtonItem = rightBarButtonItem
        tabController.navigationItem.titleView = middleButton
        
        // Delay to make LaunchScreen transition smoother
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            navigationController?.setViewControllers([tabController], animated: true)
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }

    static func userTransition(navigationController: UINavigationController?) {
        let storyboard = UIStoryboard(name: "UserStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "UserController")
        navigationController?.pushViewController(controller, animated: true)
    }
}
