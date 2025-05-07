//
//  SwipeCardView.swift
//  FoodDate
//
//  Created by Lorenzo Hobbs on 4/28/25.
//

import SwiftUI

struct SwipeCardView: View {
    let profile: UserProfile
    var body: some View {
        VStack(alignment: .center){
            Image(profile.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 400)
                .frame(maxWidth: .infinity)
                .clipped()
                .cornerRadius(20)
                .shadow(radius: 5)
            Text("\(profile.name),\(profile.age)")
                .font(.largeTitle)
                .bold()
            Text(profile.bio)
                .font(.body)
                .foregroundColor(.secondary)
            HStack{
                ForEach(profile.foods,id: \.self) { interest in
                    Text(interest)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .clipShape(Capsule())
                    
                    
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
    }
}
