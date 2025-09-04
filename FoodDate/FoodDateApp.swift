//
//  FoodDateApp.swift
//  FoodDate
//
//  Created by Lorenzo Hobbs on 9/23/24.
//
import SwiftUI
import Firebase
@main
struct FoodDateApp: App {
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    @StateObject var settings = SettingsViewModel()
    @StateObject var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                if authViewModel.isLoggedIn {
                    ContentView()
                } else {
                    LoginView()  // ← no Binding
                }
            }
            .environmentObject(settings)
            .environmentObject(authViewModel)
        }
    }
}

