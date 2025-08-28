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
            if authViewModel.isLoggedIn {
                ContentView()
                    .environmentObject(settings)
                    .environmentObject(authViewModel)
            } else {
                LoginView(isLoggedIn: $authViewModel.isLoggedIn) // <- Binding passed here
                    .environmentObject(authViewModel)
                    .environmentObject(settings)
            }
        }
    }
}

