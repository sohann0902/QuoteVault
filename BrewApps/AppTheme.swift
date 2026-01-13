//
//  AppTheme.swift
//  BrewApps
//
//  Created by Sohan Maurya on 13/01/26.
//

import SwiftUI

enum AppTheme {
    static let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.07, green: 0.08, blue: 0.18),
            Color(red: 0.12, green: 0.11, blue: 0.30),
            Color(red: 0.19, green: 0.14, blue: 0.36)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let cardGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.12),
            Color.white.opacity(0.06)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let accent = Color(red: 0.56, green: 0.44, blue: 0.96)
    static let secondaryText = Color.white.opacity(0.7)
}
