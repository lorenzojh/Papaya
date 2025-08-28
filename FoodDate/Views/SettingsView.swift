//
//  SettingsView.swift
//  FoodDate
//
//  Created by Lorenzo Hobbs on 9/25/24.
//
import SwiftUI
import Firebase
struct SettingsView: View {
    @State private var gender: String = "Male"
    @State private var showSuccess = false
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    let genders = ["Male", "Female", "Other"]
    
    var body: some View {
        NavigationView {
            Form {
                // Gender identity (not used in filtering logic yet)
                Section(header: Text("Your Gender")) {
                    Picker("Gender", selection: $gender) {
                        ForEach(genders, id: \.self) { gender in
                            Text(gender)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Preference (filters profiles)
                Section(header: Text("Dating Preference")) {
                    Picker("Looking for", selection: $settings.genderPreference) {
                        ForEach(GenderPreference.allCases) { preference in
                            Text(preference.rawValue.capitalized).tag(preference)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Age range filters
                Section(header: Text("Preferred Age Range")) {
                    VStack {
                        HStack {
                            Text("Min Age: \(settings.minAge)")
                            Spacer()
                            Text("Max Age: \(settings.maxAge)")
                        }
                        
                        RangeSliderView(
                            minAge: Binding(
                                get: { Double(settings.minAge) },
                                set: { settings.minAge = Int($0) }
                            ),
                            maxAge: Binding(
                                get: { Double(settings.maxAge) },
                                set: { settings.maxAge = Int($0) }
                            )
                        )
                    }
                    .padding(.vertical)
                }
                Section(header: Text("Search Distance")){
                    VStack(alignment: .leading){
                        Text("Show users within: \(settings.maxDistance) miles" )
                        Slider(value: Binding(
                            get: { Double(settings.maxDistance )} ,
                            set: {settings.maxDistance = Int($0)}),
                               in: 1...100, step: 1)
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
                    Button(action:{
                        logout()
                    }){
                        Text("Log out")
                            .foregroundColor(.red)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray5))
                            .cornerRadius(12)
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Settings Saved!", isPresented: $showSuccess) {
                Button("OK", role: .cancel) { }
            }
        }
    }
    
    private func saveSettings() {
        print("Settings saved!")
        showSuccess = true
        
        UserDefaults.standard.set(gender, forKey: "gender")
        UserDefaults.standard.set(settings.genderPreference.rawValue, forKey: "datingPreference")
        UserDefaults.standard.set(settings.minAge, forKey: "minAge")
        UserDefaults.standard.set(settings.maxAge, forKey: "maxAge")
        UserDefaults.standard.set(settings.maxDistance, forKey: "maxDistance")
        
    }
    func logout() {
        authViewModel.logout()
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
