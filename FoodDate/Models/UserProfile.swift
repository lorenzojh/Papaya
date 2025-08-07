//
//  UserProfile.swift
//  FoodDate
//
//  Created by Lorenzo Hobbs on 4/27/25.
//

import Foundation
import FirebaseFirestore
import CoreLocation
struct UserProfile : Identifiable{
    let id = UUID()
    let uid: String
    let name: String
    let age: String
    let bio: String
    let foods: [String]
    let imageName: String
    let gender: String
    let locationGeoPoint: GeoPoint?
    //convert geopoint to CLLocationCoordinate2D for distance filtering
    var location: CLLocationCoordinate2D? {
        guard let geoPoint = locationGeoPoint else{ return nil}
            return CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
        }

}
