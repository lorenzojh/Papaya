//
//  EmptyStateView.swift
//  FoodDate
//
//  Created by Lorenzo Hobbs on 9/7/25.
//

import Foundation
import SwiftUI

struct EmptyStateView: View {
    var title: String = "All caught up"
    var message: String = "No more profiles right now. Check back soon!"
    var systemImage: String = "sparkles"

    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: systemImage)
                .font(.system(size: 56, weight: .semibold))
                .foregroundStyle(.secondary)

            Text(title)
                .font(.title3).bold()

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .buttonStyle(.borderedProminent)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color(.systemBackground))
    }
}

