//
//  SettingsView.swift
//  FoodDate
//
//  Created by Lorenzo Hobbs on 9/25/24.
//
import SwiftUI

struct SettingsView: View {
    @State private var gender: String = "Male"
    @State private var datingPreference: String = "Women"
    @State private var minAge: Double = 18
    @State private var maxAge: Double = 50
    @State private var showSuccess = false

    
    let genders = ["Male", "Female", "Other"]
    let preferences = ["Men", "Women", "Everyone"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Your Gender")) {
                    Picker("Gender", selection: $gender) {
                        ForEach(genders, id: \.self) { gender in
                            Text(gender)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Dating Preference")) {
                    Picker("Looking for", selection: $datingPreference) {
                        ForEach(preferences, id: \.self) { preference in
                            Text(preference)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Preferred Age Range")) {
                    VStack {
                        HStack {
                            Text("Min Age: \(Int(minAge))")
                            Spacer()
                            Text("Max Age: \(Int(maxAge))")
                        }
                        RangeSliderView(minAge: $minAge, maxAge: $maxAge)
                    }
                    .padding(.vertical)
                }

                Section {
                    Button(action: saveSettings) {
                        Text("Save Settings")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
            }
            .navigationTitle("Settings") //
            .alert("Settings Saved!", isPresented: $showSuccess) {
                Button("OK", role: .cancel) { }
            }

        }
    }

    private func saveSettings() { //
        print("Settings saved!") //
        showSuccess = true       // (

        UserDefaults.standard.set(gender, forKey: "gender")
        UserDefaults.standard.set(datingPreference, forKey: "datingPreference")
        UserDefaults.standard.set(Int(minAge), forKey: "minAge")
        UserDefaults.standard.set(Int(maxAge), forKey: "maxAge")
        
    }
}

// Helper Slider View
struct RangeSliderView: View {
    @Binding var minAge: Double
    @Binding var maxAge: Double
    
    var body: some View {
        VStack {
            Slider(value: $minAge, in: 18...100, step: 1)
            Slider(value: $maxAge, in: minAge...100, step: 1)
        }
    }
}
