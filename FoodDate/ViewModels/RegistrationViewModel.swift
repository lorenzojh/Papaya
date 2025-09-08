//
//  RegistrationViewModel.swift
//  FoodDate
//
//  Created by Lorenzo Hobbs on 10/1/24.
//
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class RegistrationViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isLoading: Bool = false
    @Published var error: String?

    func registerUser() {
        // Validate input
        guard !username.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            error = "All fields are required"
            return
        }
        guard password == confirmPassword else {
            error = "Passwords don't match"
            return
        }
        // Firebase requires 6+ chars
        guard password.count >= 6 else {
            error = "Password must be at least 6 characters"
            return
        }

        error = nil
        isLoading = true

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, err in
            guard let self = self else { return }

            // Ensure all UI updates happen on main thread
            func setError(_ message: String) {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = message
                }
            }

            if let err = err {
                let nsErr = err as NSError
                // Correct way to read Firebase auth error codes:
                let code = AuthErrorCode.Code(rawValue: nsErr.code)

                switch code {
                case .invalidEmail:
                    setError("Invalid email format")
                case .weakPassword:
                    setError("Password too weak (min 6 characters)")
                case .emailAlreadyInUse:
                    setError("Email already registered")
                default:
                    setError(nsErr.localizedDescription)
                }
                return
            }

            // Success
            guard let uid = result?.user.uid else {
                setError("Could not get user ID")
                return
            }

            // Optionally: create a user document in Firestore
            let db = Firestore.firestore()
            let data: [String: Any] = [
                "uid": uid,
                "name": self.username,
                "email": self.email,
                "createdAt": FieldValue.serverTimestamp()
            ]

            db.collection("users").document(uid).setData(data) { [weak self] writeErr in
                guard let self = self else { return }
                if let writeErr = writeErr {
                    setError("Account created, but profile save failed: \(writeErr.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.error = nil
                        // TODO: navigate to next screen
                        print("User registered and profile saved. uid=\(uid)")
                    }
                }
            }
        }
    }
}
