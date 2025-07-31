//
//  ProfileView.swift
//  FoodDate
//
//  Created by Lorenzo Hobbs on 9/25/24.
//This view contains the main screen/controller for the user's profile 

import SwiftUI

// MARK: - Custom SectionView
struct SectionView<Content: View>: View {
    let header: String
    let content: Content

    init(header: String, @ViewBuilder content: () -> Content) {
        self.header = header
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(header)
                .font(.headline)
            content
        }
        .padding(.vertical)
    }
}

// MARK: - ProfileView
struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    @State private var showImagePicker = false

    var body: some View {
        ZStack {
            let pinkColor = Color(hex: "FAF9F6")
            pinkColor
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    if viewModel.isEditing {
                        // EDIT MODE
                        VStack(alignment: .center, spacing: 20) {
                            Group {
                                if let image = viewModel.profileImage {
                                    Image(uiImage: image)
                                        .resizable()

                                } else {
                                    Image("profilepicture")
                                        .resizable()

                                }
                            }
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray.opacity(0.4), lineWidth: 2))
                            .shadow(radius: 5)
                            .onTapGesture {
                                showImagePicker = true
                            }
                            .sheet(isPresented: $showImagePicker) {
                                ImagePicker(image: $viewModel.profileImage)
                            }


                            TextField("Name", text: $viewModel.name)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)

                            TextField("Age", text: $viewModel.age)
                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                        }

                        SectionView(header: "Bio") {
                            TextField("Enter Bio (something about yourself)", text: $viewModel.bio)
                                .frame(height: 100)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }

                        SectionView(header: "Foods") {
                            TextField("Enter Foods you enjoy", text: $viewModel.interests)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }

                        Button(action: {
                            withAnimation {
                                viewModel.saveProfile()
                            }
                        }) {
                            Text("Save Profile")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .transition(.opacity)
                    } else {
                        // VIEW MODE
                        ProfileCardView(viewModel: viewModel)
                            .transition(.opacity)

                        Button(action: {
                            withAnimation {
                                viewModel.isEditing = true
                            }
                        }) {
                            Text("Edit Profile")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
                .animation(.easeInOut, value: viewModel.isEditing) // ⬅️ Smooth animation on toggle
            }
        }
        .onAppear {
            viewModel.loadProfile()
        }
    }
}

// MARK: - Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
