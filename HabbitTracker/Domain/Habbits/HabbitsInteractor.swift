//
//  HabbitsInteractor.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 10.04.2025.
//
import Foundation
import Combine

class HabbitsInteractor: ObservableObject {
    private let repository: HabbitsRepository
    
    @Published var habbits: [HabbitVM] = []
    
    init(repository: HabbitsRepository) {
        self.repository = repository
    }
    
    func fetchHabbits() -> [HabbitVM] {
        let fetchResult = repository.fetchHabbits()
        
        do {
            let result: [HabbitVM] = try fetchResult.get().compactMap { habbit in
                guard let name = habbit.name,
                      let color = habbit.color else { return nil }
                
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
            
            self.habbits = result
            
            return result
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
        
        let index = self.habbits.firstIndex { habbitVM in
            habbitVM.habbitCoreData.objectID == fetched.objectID
        }
        
        guard let trackedDays = fetched.tracked as? Set<TrackedDays> else {
            if let index = index {
                self.habbits[index] = vm
            }
            
            return vm
        }
        
        for trackedDay in trackedDays {
            if let date = trackedDay.date {
                vm.trackedDays.append(DayVM(date: date, trackedDay: trackedDay))
            }
        }
        
        if let index = index {
            self.habbits[index] = vm
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
