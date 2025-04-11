//
//  HabbitParser.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 11.04.2025.
//

class HabbitHelper {
    static func parseHabitVMfromCoreData(_ habbit: Habbit) -> HabbitVM? {
        guard let name = habbit.name, let color = habbit.color else {
            return nil
        }
        
        var vm = HabbitVM(name: name, color: color, habbit: habbit)
        
        guard let trackedSet = habbit.tracked as? Set<TrackedDays> else {
            return vm
        }
        
        for tracked in trackedSet {
            if let date = tracked.date {
                vm.trackedDays.append(DayVM(date: date, trackedDay: tracked))
            }
        }
        
        return vm
    }
}
