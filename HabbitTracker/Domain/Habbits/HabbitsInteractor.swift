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
            let result: [HabbitVM] = try fetchResult.get().compactMap {
                HabbitHelper.parseHabitVMfromCoreData($0)
            }
            
            self.habbits = result
            
            return result
        } catch {
            // TODO: add handling
            
            return []
        }
    }
    
    func saveHabbit(withName name: String, andColor color: HabbitColors) {
        let saveResult = repository.save(withName: name, color: color)
        do {
            let savedHabbit = try saveResult.get()
            let parsed = HabbitHelper.parseHabitVMfromCoreData(savedHabbit)
            if let parsedHabbit = parsed {
                habbits.append(parsedHabbit)
            }
        } catch {
            // TODO: add handling
        }
    }
    
    func refetchHabbit(habbit: HabbitVM) -> HabbitVM? {
        let fetchResult = repository.fetchHabbit(habbit: habbit.habbitCoreData)
        
        guard let fetched = fetchResult else {
            return nil
        }
            
        guard let vm = HabbitHelper.parseHabitVMfromCoreData(fetched) else {
            return nil
        }
        
        let index = self.habbits.firstIndex { habbitVM in
            habbitVM.habbitCoreData.objectID == fetched.objectID
        }
        if let index = index {
            self.habbits[index] = vm
        }
        return vm
    }
    
    func remove(habbit: HabbitVM) {
        let result = repository.delete(habbit: habbit.habbitCoreData)
        _ = result.map(
{
            self.habbits = self.habbits
        .filter {
            $0.habbitCoreData.objectID != habbit.habbitCoreData.objectID
        }
})
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
