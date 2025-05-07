//
//  AppDelegate.swift
//  FoodDate
//
//  Created by Lorenzo Hobbs on 10/1/24.
//

import Foundation
import UIKit
import Firebase
import GameKit
import GoogleUtilities


class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.debug)

        return true
    }
}
