//
//  EditProfileView.swift
//  FoodDate
//
//  Created by Lorenzo Hobbs on 9/25/24.
//

import Foundation
import SwiftUI

struct EditProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Picture
                Image("profilepicture")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray.opacity(0.4), lineWidth: 2))
                    .shadow(radius: 5)

                // Username
                TextField("Username", text: $viewModel.name)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                // Age
                TextField("Age", text: $viewModel.age)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                // Bio
                TextField("Bio", text: $viewModel.bio)
                    .frame(height: 100)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                // Interests
                TextField("Favorite foods (comma separated)", text: $viewModel.interests)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                // Save Button
                Button(action: {
                    viewModel.saveProfile()
                    dismiss()
                }) {
                    Text("Save Profile")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.loadProfile()
        }
    }
}
