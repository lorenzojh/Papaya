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
    
    var body: some Scene {
    
        WindowGroup {
            ContentView()
                .environmentObject(settings)
        }
    }
}
