//
//  AuthViewModel.swift
//  FoodDate
//
//  Created by Lorenzo Hobbs on 8/28/25.
//

import SwiftUI
import FirebaseAuth

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool
    @Published var isLoading: Bool = false
    @Published var authError: String?
    @Published var currentUser: User?  // FirebaseAuth.User

    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        let user = Auth.auth().currentUser
        self.currentUser = user
        self.isLoggedIn = (user != nil)

        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self else { return }
            Task { @MainActor in
                self.currentUser = user
                self.isLoggedIn = (user != nil)
            }
        }
    }

    deinit {
        if let h = handle { Auth.auth().removeStateDidChangeListener(h) }
    }

    func signIn(email: String, password: String) async {
        authError = nil
        isLoading = true
        defer { isLoading = false }
        do {
            // If still testing with static creds, short-circuit here
            // and set isLoggedIn = true. For real Firebase, use the line below:
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.currentUser = result.user
            // isLoggedIn flips automatically via the auth listener above
        } catch {
            self.authError = error.localizedDescription
        }
    }

    func sendPasswordReset(to email: String) async {
        authError = nil
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            self.authError = error.localizedDescription
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            // listener will flip isLoggedIn & currentUser
        } catch {
            self.authError = error.localizedDescription
        }
    }
}
