//
//  HabbitColors.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 08.04.2025.
//
import UIKit

enum HabbitColors: String {
    case red = "Red"
    case orange = "Orange"
    case yellow = "Yellow"
    case green = "Green"
    case blue = "Blue"
    case indigo = "Indigo"
    case purple = "Purple"
    
    func toUIColor() -> UIColor {
        switch self {
        case .red: return .systemRed
        case .orange: return .systemOrange
        case .yellow: return .systemYellow
        case .green: return .systemGreen
        case .blue: return .systemBlue
        case .indigo: return .systemIndigo
        case .purple: return .systemPurple
        }
    }
    
    static let defaultColor: HabbitColors = .green
}
