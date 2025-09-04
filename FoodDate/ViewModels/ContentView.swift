//  ContentView.swift
//  new
//
//  Created by Lorenzo Hobbs on 3/14/24.
import SwiftUI

struct ContentView: View {
   
    @State private var selectedTab = "Profile"
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var auth: AuthViewModel

    var body: some View {
        if auth.isLoggedIn {
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
            LoginView()
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
