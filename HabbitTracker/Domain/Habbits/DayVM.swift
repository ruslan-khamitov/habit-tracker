//
//  DayVM.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 10.04.2025.
//

import Foundation

struct DayVM: Identifiable, Hashable {
    let date: Date
    let id: UUID
    
    var trackedDay: TrackedDay? = nil
    
    var tracked: Bool {
        trackedDay != nil
    }
    
    func getStartOfDay() -> Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: date)
    }
}
