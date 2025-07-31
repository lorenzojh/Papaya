//
//  SettingsViewModel.swift
//  FoodDate
//
//  Created by Lorenzo Hobbs on 7/17/25.
//

import Foundation

enum GenderPreference: String, CaseIterable, Identifiable {
    case all
    case male
    case female

    var id: String { rawValue }
}

class SettingsViewModel: ObservableObject{
    @Published var genderPreference: GenderPreference = .all
    @Published var minAge: Int = 18
    @Published var maxAge: Int = 50
    
}
