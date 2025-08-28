//
//  AuthViewModel.swift
//  FoodDate
//
//  Created by Lorenzo Hobbs on 8/28/25.
//

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    init(){
        
        self.isLoggedIn = Auth.auth().currentUser != nil
    }
    func logout(){
        do{
            try Auth.auth().signOut()
            isLoggedIn = false
                 
        }catch {
            print("Error logging out")
        }
    }
}
