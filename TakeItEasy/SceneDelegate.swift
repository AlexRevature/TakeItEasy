//
//  SceneDelegate.swift
//  TakeItEasy
//
//  Created by Alex Cabrera on 1/10/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let keepCredentials = UserDefaults.standard.bool(forKey: "keepCredentials")
        if !keepCredentials {
            let status: CredentialStatus = AuthManager.deleteCredentials()
            if (status == .failure) {
                return
            }
            UserDefaults.standard.set(true, forKey: "keepCredentials")
        }

        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)

        let rootNC = createNavigation()
        self.window?.rootViewController = rootNC

        let username = UserDefaults.standard.string(forKey: "currentUser")
        if username != nil {
            UserManager.currentUser = UserManager.findUser(username: username!)
            ControllerManager.mainTransition(navigationController: rootNC)

        } else {
            let storyboard = UIStoryboard(name: "AccountStoryboard", bundle: nil)
            let rootVC = storyboard.instantiateViewController(identifier: "LandingController")
            rootNC.setViewControllers([rootVC], animated: false)
        }

        self.window?.rootViewController = rootNC
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        CoreManager.saveContext()
    }

    @objc
    func logOut() {
        UserDefaults.standard.removeObject(forKey: "currentUser")

        let storyboard = UIStoryboard(name: "AccountStoryboard", bundle: nil)
        let rootVC = storyboard.instantiateViewController(identifier: "LandingController")
        let rootNC = createNavigation()
        rootNC.setViewControllers([rootVC], animated: false)

        self.window?.rootViewController = rootNC
    }

    func createNavigation() -> UINavigationController {
        let rootNC = UINavigationController()

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = ThemeManager.lightTheme.primaryColor
        appearance.shadowColor = nil
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
           .font: UIFont(name: "Courier New Bold", size: 18) ?? UIFont.italicSystemFont(ofSize: 18)
        ]

        rootNC.navigationBar.standardAppearance = appearance
        rootNC.navigationBar.scrollEdgeAppearance = appearance
        rootNC.navigationBar.compactAppearance = appearance
        rootNC.navigationBar.isTranslucent = false
        rootNC.navigationBar.tintColor = UIColor.white

        return rootNC
    }


}

