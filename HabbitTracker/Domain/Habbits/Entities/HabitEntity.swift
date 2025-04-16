//
//  HabitVM.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 10.04.2025.
//
import Foundation

struct HabitEntity: Identifiable, Hashable {
    let id: UUID
    let name: String
    let color: HabbitColors
    let trackedDays: [HabitDay]
    
    init(id: UUID, name: String, color: String, trackedDays: [HabitDay] = []) {
        self.id = id
        self.name = name
        self.trackedDays = trackedDays
        self.color = HabbitColors.parse(from: color)
    }
}
