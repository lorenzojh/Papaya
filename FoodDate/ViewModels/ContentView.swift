//  ContentView.swift
//  new
//
//  Created by Lorenzo Hobbs on 3/14/24.
import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false
    @State private var selectedTab = "Profile"
    @EnvironmentObject var settings: SettingsViewModel

    var body: some View {
        if isLoggedIn {
            TabView(selection: $selectedTab) {
                ProfileView()
                    .tabItem { Label("Profile", systemImage: "person") }
                SwipeView()
                    .tabItem { Label("Swipe", systemImage: "person.2") }
                MessagesView()
                    .tabItem { Label("Messages", systemImage: "message")}
                SettingsView()
                    .tabItem { Label("Settings", systemImage: "gear") }
            }
            .navigationBarTitle("Papaya")
        } else {
            LoginView(isLoggedIn: $isLoggedIn)
        }
    }
}

//  Custom navigation title view
struct FoodDateTitle: View {
    var body: some View {
        HStack {
            Spacer()
            Text("Papaya")
                .font(.title)
                .bold()
            Spacer()
        }
        .padding()
        .background(Color.red)
        .foregroundColor(.white)
        .cornerRadius(10)
    }
}
