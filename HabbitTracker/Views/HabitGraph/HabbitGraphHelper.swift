//
//  HabbitGraphHelper.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 10.04.2025.
//

import CoreFoundation

struct HabitGraphUI {
    static let tileSpacing: CGFloat = 4
    static let tileSize: CGFloat = 16
    static let titleHeight: CGFloat = 34
    static let titlePadding: CGFloat = 12
    
    static var graphPartHeight: CGFloat {
        tileSize * 7 + tileSpacing * 6
    }
    
    static var totalHeight: CGFloat {
        graphPartHeight + titleHeight + titlePadding * 2
    }
}
