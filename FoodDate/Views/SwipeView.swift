//
//  SwipeView.swift
//  FoodDate
//
//  Purpose: Displays swipeable stack of profiles with matching logic
//
//  Created by Lorenzo Hobbs on 9/25/24.
//
import SwiftUI
import CoreLocation
import FirebaseFirestore
import FirebaseFirestoreSwift
struct SwipeView: View {
    @State private var profiles: [UserProfile] = []          // ← no dummy
    @State private var topProfileIndex = 0
    @State private var dragOffset: CGSize = .zero
    @State private var likedProfiles: [UserProfile] = []
    @State private var showMatch = false
    @State private var matchedProfile: UserProfile?
    @State private var swipeStatus: String?
    @EnvironmentObject var settings: SettingsViewModel
    @StateObject private var locationManager = LocationManager()

    // Firestore listener
    @State private var listener: ListenerRegistration?

    var body: some View {
        ZStack {
            if topProfileIndex < profiles.count {
                ForEach(Array(profiles.enumerated().reversed()), id: \.element.id) { index, profile in
                    if index >= topProfileIndex {
                        SwipeCardView(profile: profile) // update to support AsyncImage if using URLs
                            .offset(x: index == topProfileIndex ? dragOffset.width : 0,
                                    y: index == topProfileIndex ? dragOffset.height : CGFloat(index - topProfileIndex) * 10)
                            .scaleEffect(index == topProfileIndex ? 1.0 : 0.95)
                            .rotationEffect(.degrees(index == topProfileIndex ? Double(dragOffset.width / 20) : 0))
                            .gesture(
                                DragGesture()
                                    .onChanged { value in dragOffset = value.translation }
                                    .onEnded { value in handleSwipe(value: value.translation); dragOffset = .zero }
                            )
                            .animation(.spring(), value: dragOffset)
                    }
                }
            } else {
                // ... your “all caught up” view ...
                EmptyStateView()
            }

            // ... your swipeStatus + match popup remain unchanged ...
        }
        .padding()
        .onAppear {
            _ = locationManager
            attachProfilesListener()
        }
        .onDisappear {
            listener?.remove()
            listener = nil
        }
        .onChange(of: settings.genderPreference) { _ in filterAndApply() }
        .onChange(of: locationManager.userLocation?.latitude) { _ in filterAndApply() }
    }

    private func attachProfilesListener() {
        let db = Firestore.firestore()
        // Basic query; you can server-filter by gender/age later
        listener?.remove()
        listener = db.collection("users").addSnapshotListener { snapshot, error in
            guard let docs = snapshot?.documents else { return }
            let fetched: [UserProfile] = docs.compactMap { try? $0.data(as: UserProfile.self) }
            // Do NOT filter here yet; store all, then apply client filters
            self.rawProfiles = fetched
            self.filterAndApply()
        }
    }

    // keep a raw cache to re-filter on settings/location changes
    @State private var rawProfiles: [UserProfile] = []

    private func filterAndApply() {
        guard let currentLocation = locationManager.userLocation else {
            profiles = []
            return
        }

        // Filter by age/gender (same logic as before, but types updated)
        let filteredAgeGender = rawProfiles.filter { p in
            let matchesAge = (p.age >= settings.minAge && p.age <= settings.maxAge)

            let matchesGender: Bool
            switch settings.genderPreference {
            case .all: matchesGender = true
            case .male: matchesGender = p.gender.lowercased() == "male"
            case .female: matchesGender = p.gender.lowercased() == "female"
            }

            return matchesAge && matchesGender
        }

        // Distance filter
        profiles = filterByDistance(currentUserLocation: currentLocation, users: filteredAgeGender)
        topProfileIndex = 0
    }

    private func handleSwipe(value: CGSize) {
        if value.width > 100 { swipeRight() }
        else if value.width < -100 { swipeLeft() }
        else { dragOffset = .zero }
    }

    private func swipeRight() {
        guard topProfileIndex < profiles.count else { return }
        let liked = profiles[topProfileIndex]
        likedProfiles.append(liked)

        if Bool.random() {
            matchedProfile = liked
            showMatch = true
        }
        swipeStatus = "✅"
        topProfileIndex += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { swipeStatus = nil }
    }

    private func swipeLeft() {
        guard topProfileIndex < profiles.count else { return }
        swipeStatus = "❌"
        topProfileIndex += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { swipeStatus = nil }
    }

    private func filterByDistance(currentUserLocation: CLLocationCoordinate2D, users: [UserProfile]) -> [UserProfile] {
        let maxDist = UserDefaults.standard.double(forKey: "maxDistance")
        return users.filter { user in
            guard let loc = user.location else { return false }
            let userLoc = CLLocation(latitude: loc.latitude, longitude: loc.longitude)
            let currentLoc = CLLocation(latitude: currentUserLocation.latitude, longitude: currentUserLocation.longitude)
            let distanceInMiles = userLoc.distance(from: currentLoc) / 1609.34
            return distanceInMiles <= maxDist
        }
    }
}
