//
//  LocationManager.swift
//  FoodDate
//
//  Created by Lorenzo Hobbs on 8/6/25.
//

import Foundation
import CoreLocation
// inheirt NSObject for delegation, conforms to swiftui to track changes, and recieve location updates
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate{
    // built in location manager
    private let manager = CLLocationManager()
    
    //location for swiftui
    @Published var userLocation: CLLocationCoordinate2D?
    // set class as delegate to recieve location updates
    override init(){
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        //request when in use location permission
        manager.requestWhenInUseAuthorization()
      //  print("🌀 LocationManager initialized and asked for permission")

        //start getting location updates
        manager.startUpdatingLocation()
        
    }
    //delegate callback when location changes
    //once location updates store and stop updating
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {return}
        userLocation = location.coordinate
        manager.stopUpdatingLocation()
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("✅ Location permission granted")
            manager.startUpdatingLocation()
        case .denied, .restricted:
            print("❌ Location permission denied")
        case .notDetermined:
            print("📡 Waiting for location permission...")
        @unknown default:
            break
        }
    }

}
