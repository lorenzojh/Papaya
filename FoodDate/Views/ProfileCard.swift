//
//  ProfileCard.swift
//  FoodDate
//
//  Created by Lorenzo Hobbs on 9/25/24.
//This file shows the profile in a clean and stylish form

import Foundation
import SwiftUI

struct ProfileCardView: View {
    @ObservedObject var viewModel : ProfileViewModel
    
    var body: some View{
        VStack(alignment: .leading, spacing: 12){
            
            Image("profilepicture")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 280)
                .frame(maxWidth: .infinity)
                .clipped()
                .cornerRadius(25)
                .shadow(radius:10)
            
            Text(viewModel.name)
                .font(.title)
                .bold()
            Text(viewModel.age)
                .font(.title)
                .bold()
            Text(viewModel.bio)
                .font(.subheadline)
                .foregroundColor(.secondary)
            ScrollView(.horizontal,showsIndicators: false){
                HStack{
                    ForEach(viewModel.interests.components(separatedBy: ","), id: \.self){ interest in
                        Text(interest.trimmingCharacters(in: .whitespaces))
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.2))
                            .foregroundColor(.blue)
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(30)
        .shadow(radius: 5)
        .padding(.horizontal)
        
        
    }
    
}
