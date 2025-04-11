//
//  HabbitVM.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 10.04.2025.
//
import Foundation

struct HabbitVM: Identifiable, Hashable {
    var name: String
    var color: HabbitColors
    var id: UUID = UUID()
    var trackedDays: [DayVM] = []
    
    var habbitCoreData: Habbit
    
    init(name: String, color: String, habbit: Habbit) {
        self.name = name
        self.habbitCoreData = habbit
        
        let parsedColor = HabbitColors(rawValue: color)
        guard let parsedColor else {
            self.color = HabbitColors.defaultColor
            return
        }
        
        self.color = parsedColor
    }
}
