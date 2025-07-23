//
//  EditProfileView.swift
//  FoodDate
//
//  Created by Lorenzo Hobbs on 9/25/24.
//
import SwiftUI
import Foundation

struct EditProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss

    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = UIImage(named: "profilepicture")

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Picture
                profileImageView

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
                    if let image = selectedImage {
                        viewModel.profileImage = image
                    }
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
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage)
        }
    }

    // MARK: - Profile Image View
    private var profileImageView: some View {
        Group {
            if let selectedImage = self.selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()

            } else if let vmImage = self.viewModel.profileImage {
                Image(uiImage: vmImage)
                    .resizable()
            } else {
                Image("profilepicture") // fallback default image name
                    .resizable()

            }
        }
        .aspectRatio(contentMode: .fill)
        .frame(width: 200, height: 200)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.gray.opacity(0.4), lineWidth: 2))
        .shadow(radius: 5)
        .onTapGesture {
            self.showImagePicker = true
        }
    }
}
