//
//  ProfileViewModel.swift
//  FoodDate
//h
//  Created by Lorenzo Hobbs on 9/25/24.
//This file contains definitions of variables and some controlling functions like loadProfile and saveProfile
import Combine
import Foundation
class ProfileViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var bio: String = ""
    @Published var age: String = ""
    @Published var interests: String = ""
    @Published var isEditing: Bool = false
    
    private let defaults = UserDefaults.standard
    
    func loadProfile() {
        name = defaults.string(forKey: "name") ?? ""
        bio = defaults.string(forKey: "bio") ?? ""
        interests = defaults.string(forKey: "interests") ?? ""
        age = defaults.string(forKey: "age") ?? ""
        isEditing = name.isEmpty && bio.isEmpty && interests.isEmpty && age.isEmpty
    }
    
    func saveProfile() {
        defaults.set(name, forKey: "name")
        defaults.set(bio, forKey: "bio")
        defaults.set(interests, forKey: "interests")
        defaults.set(age, forKey: "age")
        isEditing = false
    }
    
    func validateInput() -> Bool {
        // Add validation logic here
        return true
    }
}
