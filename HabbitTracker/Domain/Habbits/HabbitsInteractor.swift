//
//  HabbitsInteractor.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 10.04.2025.
//

class HabbitsInteractor {
    private let repository: HabbitsRepository
    
    var habbits: [Habbit] = []
    
    init(repository: HabbitsRepository) {
        self.repository = repository
    }
    
    func fetchHabbits() -> [HabbitVM] {
        let fetchResult = repository.fetchHabbits()
        
        do {
            let result = try fetchResult.get()
            self.habbits = result
            
            return result.compactMap { habbit in
                guard let name = habbit.name,
                      let color = habbit.color else {
                    return nil
                }
                
                var vm = HabbitVM(name: name, color: color, habbit: habbit)
                
                if let trackedSet = habbit.tracked as? Set<TrackedDays> {
                    for tracked in trackedSet {
                        if let date = tracked.date {
                            vm.trackedDays.append(DayVM(date: date, trackedDay: tracked))
                        }
                    }
                }
                
                return vm
            }
        } catch {
            // TODO: add warning
            
            return []
        }
    }
    
    func saveHabbit(withName name: String, andColor color: HabbitColors) {
        _ = repository.save(withName: name, color: color)
    }
    
    func refetchHabbit(habbit: HabbitVM) -> HabbitVM? {
        let fetchResult = repository.fetchHabbit(habbit: habbit.habbitCoreData)
        
        guard let fetched = fetchResult else {
            return nil
        }
            
        guard let name = fetched.name, let color = fetched.color else {
            return nil
        }
        
        var vm = HabbitVM(name: name, color: color, habbit: fetched)
        
        if let trackedDays = fetched.tracked as? Set<TrackedDays> {
            for trackedDay in trackedDays {
                if let date = trackedDay.date {
                    vm.trackedDays.append(DayVM(date: date, trackedDay: trackedDay))
                }
            }
        }
        
        return vm
    }
    
    
    
    // Tracking days
    private func track(day: DayVM, forHabbit habbit: Habbit) {
        let dateToTrack = day.getStartOfDay()
        _ = repository.track(day: dateToTrack, forHabbit: habbit)
    }
    
    private func untrack(day: DayVM) {
        guard let trackedDay = day.trackedDay else { return }
        _ = repository.untrack(day: trackedDay)
    }
    
    func toggleTrack(day: DayVM, forHabbit habbit: HabbitVM) {
        let toggleDate = day.getStartOfDay()
        
        let alreadyTracked = habbit.trackedDays.first {
            $0.date == toggleDate
        }
        if let alreadyTracked {
            untrack(day: alreadyTracked)
        } else {
            track(day: day, forHabbit: habbit.habbitCoreData)
        }
    }
}
