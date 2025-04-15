//
//  HabitHelper.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 11.04.2025.
//

class HabitHelper {
    static func parseHabitVMfromCoreData(_ habit: Habit) -> HabitVM? {
        guard let id = habit.id, let name = habit.name, let color = habit.color else {
            return nil
        }
        
        var vm = HabitVM(id: id, name: name, color: color, habit: habit)
        
        guard let trackedSet = habit.tracked as? Set<TrackedDay> else {
            return vm
        }
        
        for tracked in trackedSet {
            if let date = tracked.date, let id = tracked.id  {
                vm.trackedDays.append(DayVM(date: date, id: id, trackedDay: tracked))
            }
        }
        
        return vm
    }
}
