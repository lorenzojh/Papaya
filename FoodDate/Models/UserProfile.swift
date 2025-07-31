//
//  UserProfile.swift
//  FoodDate
//
//  Created by Lorenzo Hobbs on 4/27/25.
//

import Foundation
struct UserProfile : Identifiable{
    let id = UUID()
    let uid: String
    let name: String
    let age: String
    let bio: String
    let foods: [String]
    let imageName: String
    let gender: String
    
}
