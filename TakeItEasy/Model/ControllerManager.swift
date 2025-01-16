//
//  ControllerManager.swift
//  TakeItEasy
//
//  Created by Alex Cabrera on 1/16/25.
//

import UIKit

class ControllerManager {

    static func mainTransition(navigationController: UINavigationController?) {

        let quizSB = UIStoryboard(name: "QuizzesStoryboard", bundle: nil)
        let quizListController = quizSB.instantiateViewController(identifier: "QuizListController")

        let notesSB = UIStoryboard(name: "NotesStoryboard", bundle: nil)
        let notesTableController = notesSB.instantiateViewController(identifier: "NotesViewController")

        let webSB = UIStoryboard(name: "WebViewStoryboard", bundle: nil)
        let webViewController = webSB.instantiateViewController(identifier: "webViewStoryboard")

        let tabController = UITabBarController()
        tabController.viewControllers = [quizListController]

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
        }
    }
}
