//
//  TestView.swift
//  FoodDate
//
//  Created by Lorenzo Hobbs on 4/28/25.
//
import SwiftUI

struct TestView: View {
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Button(action: {
                        print("Button was tapped!")
                    }) {
                        Text("Tap me")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                }
            }
            .navigationTitle("Test Button")
        }
    }
}
