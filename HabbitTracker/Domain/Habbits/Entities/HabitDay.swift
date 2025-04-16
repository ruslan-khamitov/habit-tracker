//
//  DayVM.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 10.04.2025.
//

import Foundation

struct HabitDay: Identifiable, Hashable {
    let id: UUID
    let date: Date
    let isTracked: Bool
    
    func getStartOfDay() -> Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: date)
    }
}
