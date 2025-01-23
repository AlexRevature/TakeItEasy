//
//  AppDelegate.swift
//  TakeItEasy
//
//  Created by Alex Cabrera on 1/10/25.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        TitleLabel.appearance().textColor = ThemeManager.lightTheme.boldText
        ErrorLabel.appearance().textColor = UIColor.red

        var actionConfiguration = ActionButton.Configuration.filled()
        actionConfiguration.baseBackgroundColor = ThemeManager.lightTheme.primaryColor
        actionConfiguration.baseForegroundColor = ThemeManager.lightTheme.alternateText
        ActionButton.appearance().configuration = actionConfiguration

        var alternateConfiguration = ActionButton.Configuration.filled()
        alternateConfiguration.baseBackgroundColor = UIColor.systemGray2
        alternateConfiguration.baseForegroundColor = ThemeManager.lightTheme.alternateText
        AlternateButton.appearance().configuration = alternateConfiguration

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

