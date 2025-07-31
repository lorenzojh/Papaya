//
//  RegistrationViewModel.swift
//  FoodDate
//
//  Created by Lorenzo Hobbs on 10/1/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class RegistrationViewModel : ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    func registerUser() {
        // Validate input
        if username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            error = "All fields are required"
            return
        }
        
        if password != confirmPassword {
            error = "Passwords don't match"
            return
        }
        
        // Call Firebase registration API
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            self.isLoading = false
            if let error = error {
                print("Error Details:")
                            print("Error Code: \(error._code)")
                            print("Error Message: \(error.localizedDescription)")
                            self.error = error.localizedDescription
                let errorCode = AuthErrorCode(rawValue: error._code)
                switch errorCode {
                case .invalidEmail:
                    self.error = "Invalid email format"
                case .weakPassword:
                    self.error = "Password too weak"
                case .emailAlreadyInUse:
                    self.error = "Email already registered"
                default:
                    self.error = error.localizedDescription
                }
            } else {
                // Handle successful registration
                print("User registered successfully: \(String(describing: result?.user.uid))")
                // You can also navigate to the next screen or perform other actions here
            }
        }
    }
}
