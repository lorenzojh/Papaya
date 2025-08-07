//
//  ProfileViewModel.swift
//  FoodDate
//h
//  Created by Lorenzo Hobbs on 9/25/24.
//This file contains definitions of variables and some controlling functions like loadProfile and saveProfile
import Combine
import Foundation
import UIKit
import Firebase
import CoreLocation

class ProfileViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var bio: String = ""
    @Published var age: String = ""
    @Published var interests: String = ""
    @Published var isEditing: Bool = false
    @Published var profileImage: UIImage?

    private let defaults = UserDefaults.standard
    private let imageFileName = "profileImage.png"

    // MARK: - Load Profile
    func loadProfile() {
        name = defaults.string(forKey: "name") ?? ""
        bio = defaults.string(forKey: "bio") ?? ""
        interests = defaults.string(forKey: "interests") ?? ""
        age = defaults.string(forKey: "age") ?? ""
        isEditing = name.isEmpty && bio.isEmpty && interests.isEmpty && age.isEmpty

        // Load profile image
        if let imagePath = getImagePath(),
           FileManager.default.fileExists(atPath: imagePath.path),
           let data = try? Data(contentsOf: imagePath),
           let image = UIImage(data: data) {
            profileImage = image
        }
    }

    // MARK: - Save Profile
    func saveProfile() {
        defaults.set(name, forKey: "name")
        defaults.set(bio, forKey: "bio")
        defaults.set(interests, forKey: "interests")
        defaults.set(age, forKey: "age")
        isEditing = false

        // Save profile image
        if let image = profileImage,
           let data = image.pngData(),
           let path = getImagePath() {
            try? data.write(to: path)
        }
    }
    //Update user location function
    func updateUserLocation(_ coordinate: CLLocationCoordinate2D) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No logged-in user.")
            return
        }

        let geoPoint = GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)

        let db = Firestore.firestore()
        db.collection("users").document(userID).updateData([
            "location": geoPoint
        ]) { error in
            if let error = error {
                print("❌ Error updating location: \(error.localizedDescription)")
            } else {
                print("✅ Successfully updated location.")
            }
        }
    }


    // MARK: - Helpers

    private func getImagePath() -> URL? {
        guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documents.appendingPathComponent(imageFileName)
    }

    func validateInput() -> Bool {
        // Add validation if needed
        return true
    }
    
}
