//
//  DummyData.swift
//  FoodDate
//
//  Created by Lorenzo Hobbs on 4/28/25.
//

import Foundation
import FirebaseFirestore
let dummyProfiles: [UserProfile] = [
    UserProfile(uid: "test", name: "Maya", age: "24", bio: "Sushi and loves Jesus", foods: ["sushi", "thai"], imageName: "maya",gender: "female",locationGeoPoint: GeoPoint(latitude: 36.1699, longitude: -115.1398)), // Las Vegas
    UserProfile(uid: "test", name: "Chris", age: "29", bio: "Climbing and gaming", foods: ["italian", "ramen"], imageName: "chris",gender: "male",locationGeoPoint: GeoPoint(latitude: 34.0522, longitude: -118.2437) // Los Angeles
    ),
    UserProfile(uid: "test", name: "Ava", age: "27", bio: "Teaching and swimming", foods: ["seafood", "fish"], imageName: "ava",gender: "female",locationGeoPoint: GeoPoint(latitude: 37.7749, longitude: -122.4194) // San Francisco
               ),
    UserProfile(uid: "test", name: "Liam", age: "32", bio: "Gym Junkie and history nerd", foods: ["mediterranean", "greek"], imageName: "liam",gender: "male",  locationGeoPoint: GeoPoint(latitude: 33.4484, longitude: -112.0740) // Phoenix
               ),
    UserProfile(uid: "HTSEVQg4rWPJYaMOyEdQxmfl9772", name: "Katie", age: "24",bio: "Whiskey, white lies", foods: ["icing", "desserts(pies)"], imageName: "katie",gender: "female",locationGeoPoint: GeoPoint(latitude: 32.7157, longitude: -117.1611) // San Diego
               )
]
