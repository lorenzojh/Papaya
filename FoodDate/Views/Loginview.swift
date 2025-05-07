//
//  loginView.swift
//  FoodDate
//
//  Created by Lorenzo Hobbs on 9/23/24.
//

import Foundation
import SwiftUI
//create a login view
struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @State private var showRegistration = false
    var body: some View{
        ZStack{
            let pinkColor = Color(hex: "f194c7")
            LinearGradient(gradient: Gradient(colors: [pinkColor]),startPoint:.topTrailing, endPoint: .bottomTrailing)
                .ignoresSafeArea(.all)
            VStack {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay(
                        Color(hex: "f194c7")
                            .opacity(0.6)
                    )
                Text("Login")
                    .font(.title)
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                
                }
                Text("Login")
                    .padding()
                    .bold()
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue)
                    )
                
                    .onTapGesture {
                        self.validateCredentials()
                    }
                //add register button
                Button("Register"){
                    showRegistration.toggle()
                }
                .padding()
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius:10)
                        .fill(Color.mint)
                    )
            }
        }
        .sheet(isPresented: $showRegistration){
            RegistrationView()
        }
    }
        func validateCredentials(){
            let ValidateUsername = "Lorenzojh"
            let ValidatePassword = "Juicewrld999"
            if username == ValidateUsername && password == ValidatePassword {
                self.isLoggedIn = true
            }else{
                self.errorMessage = "Invalid Username or password"
            }
            
            
        }
    }
//extension that adds custom initializers to color struct
extension Color {
    //initialize a color from a hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct Previews_Loginview_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isLoggedIn:.constant(false))
    }
}
