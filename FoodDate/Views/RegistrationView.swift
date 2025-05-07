//
//  RegistrationView.swift
//  FoodDate
//
//  Created by Lorenzo Hobbs on 9/30/24.
//

 import SwiftUI
 import FirebaseAuth
 
struct RegistrationView: View {
    @StateObject var viewModel = RegistrationViewModel()
    
    var body: some View {
        
        VStack {
            TextField("Username", text: $viewModel.username)
                .padding()
            TextField("Email", text: $viewModel.email)
                .padding()
            SecureField("Password", text: $viewModel.password)
                .padding()
            SecureField("Confirm Password", text: $viewModel.confirmPassword)
                .padding()
            Button(action: {
                viewModel.registerUser()
            }) {
                Text("Register")
            }
            if let error = viewModel.error {
                Text(error)
                    .foregroundColor(.red)
            }
        }
    }
}
    
    struct Previews_RegistrationView_Previews: PreviewProvider {
        static var previews: some View {
            RegistrationView()
        }
    }

 

