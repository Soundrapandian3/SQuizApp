//
//  AppDelegate.swift
//  QuizApp
//
//  Created by Soundrapandian T on 30/07/20.
//  Copyright © 2020 Soundrapandian T. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if #available(iOS 13.0, *)
        {
        window?.overrideUserInterfaceStyle = .light
        }
        return true
    }

}

