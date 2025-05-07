//
//  SwipeView.swift
//  FoodDate
//
//  Purpose: Displays swipeable stack of profiles with matching logic
//
//  Created by Lorenzo Hobbs on 9/25/24.
//

import SwiftUI

struct SwipeView: View {
    @State private var profiles = dummyProfiles
    @State private var topProfileIndex = 0
    @State private var dragOffset: CGSize = .zero
    @State private var likedProfiles: [UserProfile] = []
    @State private var showMatch: Bool = false
    @State private var matchedProfile: UserProfile? = nil
    @State private var swipeStatus: String? = nil

    var body: some View {
        ZStack {
            if topProfileIndex < profiles.count {
                // Stack of profiles
                ForEach(Array(profiles.enumerated().reversed()), id: \.element.id) { index, profile in
                    if index >= topProfileIndex {
                        SwipeCardView(profile: profile)
                            .offset(x: index == topProfileIndex ? dragOffset.width : 0,
                                    y: index == topProfileIndex ? dragOffset.height : CGFloat(index - topProfileIndex) * 10)
                            .scaleEffect(index == topProfileIndex ? 1.0 : 0.95)
                            .rotationEffect(.degrees(index == topProfileIndex ? Double(dragOffset.width / 20) : 0))
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        dragOffset = value.translation
                                    }
                                    .onEnded { value in
                                        handleSwipe(value: value.translation)
                                        dragOffset = .zero
                                    }
                            )
                            .animation(.spring(), value: dragOffset)
                    }
                }
            }else {
                VStack(spacing: 20) {
                    Spacer()
                    
                    // Sleek Image
                    Image(systemName: "person.crop.circle.badge.checkmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.blue)
                        .padding()

                    Text("You're all caught up!")
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(.top)
                    
                    Text("Check back later for more profiles.")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                }
                .padding()
                .transition(.opacity)

            }
            
            // Swipe feedback
            if let status = swipeStatus {
                VStack {
                    Spacer()
                    Text(status)
                        .font(.system(size: 60))
                        .foregroundColor(status == "✅" ? .green : .red)
                        .transition(.opacity)
                        .padding()
                }
                .animation(.easeInOut, value: swipeStatus)
            }
            
            // Match pop-up
            if showMatch, let matched = matchedProfile {
                VStack {
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Text("It's a Match! ❤️")
                            .font(.largeTitle)
                            .bold()
                        
                        Text("You and \(matched.name) liked each other!")
                            .font(.title2)
                        
                        Image(matched.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                        
                        Button(action: {
                            showMatch = false
                        }) {
                            Text("Keep Swiping")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                        .padding(.top)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .padding()
                    
                    Spacer()
                }
                .background(Color.black.opacity(0.5))
                .ignoresSafeArea()
                .transition(.opacity)
            }
        }
        .padding()
    }

    private func handleSwipe(value: CGSize) {
        if value.width > 100 {
            swipeRight()
        } else if value.width < -100 {
            swipeLeft()
        } else {
            dragOffset = .zero // not enough swipe, reset position
        }
    }

    private func swipeRight() {
        let likedProfile = profiles[topProfileIndex]
        likedProfiles.append(likedProfile)
        
        // Random match for demo
        if Bool.random() {
            matchedProfile = likedProfile
            showMatch = true
            print("Matched with \(likedProfile.name) ❤️")
        } else {
            print("Swiped right ✅ but no match")
        }
        
        swipeStatus = "✅"
        topProfileIndex += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            swipeStatus = nil
        }
    }

    private func swipeLeft() {
        print("Swiped left ❌")
        
        swipeStatus = "❌"
        topProfileIndex += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            swipeStatus = nil
        }
    }
}
