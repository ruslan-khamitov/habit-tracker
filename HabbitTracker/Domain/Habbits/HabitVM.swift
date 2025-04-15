//
//  HabitVM.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 10.04.2025.
//
import Foundation

struct HabitVM: Identifiable, Hashable {
    var id: UUID
    var name: String
    var color: HabbitColors
    var trackedDays: [DayVM] = []
    
    var habitCoreData: Habit
    
    init(id: UUID, name: String, color: String, habit: Habit) {
        self.id = id
        self.name = name
        self.habitCoreData = habit
        
        let parsedColor = HabbitColors(rawValue: color)
        guard let parsedColor else {
            self.color = HabbitColors.defaultColor
            return
        }
        
        self.color = parsedColor
    }
}
