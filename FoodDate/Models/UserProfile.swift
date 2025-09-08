//
//  UserProfile.swift
//  FoodDate
//
//  Created by Lorenzo Hobbs on 4/27/25.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreLocation

struct UserProfile: Identifiable, Codable {
    // Use Firestore document ID, not a random UUID
    @DocumentID var id: String?

    var uid: String
    var name: String
    var age: Int              // keep as Int for filtering
    var bio: String
    var foods: [String]
    var imageName: String
    var gender: String
    var locationGeoPoint: GeoPoint?   // Firestore's GeoPoint is Codable

    // Not stored in Firestore — just a computed helper for your distance math
    var location: CLLocationCoordinate2D? {
        guard let gp = locationGeoPoint else { return nil }
        return CLLocationCoordinate2D(latitude: gp.latitude, longitude: gp.longitude)
    }

    // If your Firestore data has age as a *String* in some docs,
    // this custom decoder will accept both Int and String gracefully.
    enum CodingKeys: String, CodingKey {
        case id, uid, name, age, bio, foods, imageName, gender, locationGeoPoint
    }

    init(uid: String,
         name: String,
         age: Int,
         bio: String,
         foods: [String],
         imageName: String,
         gender: String,
         locationGeoPoint: GeoPoint?) {
        self.uid = uid
        self.name = name
        self.age = age
        self.bio = bio
        self.foods = foods
        self.imageName = imageName
        self.gender = gender
        self.locationGeoPoint = locationGeoPoint
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try? c.decode(String.self, forKey: .id)
        self.uid = try c.decode(String.self, forKey: .uid)
        self.name = try c.decode(String.self, forKey: .name)

        // age: accept Int or String
        if let intAge = try? c.decode(Int.self, forKey: .age) {
            self.age = intAge
        } else if let strAge = try? c.decode(String.self, forKey: .age),
                  let intFromStr = Int(strAge) {
            self.age = intFromStr
        } else {
            // Fallback if field missing or malformed
            self.age = 18
        }

        self.bio = (try? c.decode(String.self, forKey: .bio)) ?? ""
        self.foods = (try? c.decode([String].self, forKey: .foods)) ?? []
        self.imageName = (try? c.decode(String.self, forKey: .imageName)) ?? ""
        self.gender = (try? c.decode(String.self, forKey: .gender)) ?? ""
        self.locationGeoPoint = try? c.decode(GeoPoint.self, forKey: .locationGeoPoint)
    }
}
