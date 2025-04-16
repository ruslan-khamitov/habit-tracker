//
//  HabitHelper.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 11.04.2025.
//

class HabitMapper {
    static func map(from habit: Habit) -> HabitEntity? {
        guard let id = habit.id, let name = habit.name, let color = habit.color else {
            return nil
        }
        
        guard let trackedSet = habit.tracked as? Set<TrackedDay> else {
            return HabitEntity(id: id, name: name, color: color)
        }
        
        let trackedDays: [HabitDay] = trackedSet.compactMap { tracked in
            guard let id = tracked.id, let date = tracked.date else {
                return nil
            }
            
            return HabitDay(id: id, date: date, isTracked: true)
        }
        
        return HabitEntity(id: id, name: name, color: color, trackedDays: trackedDays)
    }
}

extension Habit {
    var habitEntity: HabitEntity? {
        HabitMapper.map(from: self)
    }
}
