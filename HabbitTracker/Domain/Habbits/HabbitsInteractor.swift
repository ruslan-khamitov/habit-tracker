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
                
                var vm = HabbitVM(name: name, color: color)
                
                if let trackedSet = habbit.tracked as? Set<TrackedDays> {
                    for tracked in trackedSet {
                        if let date = tracked.date {
                            vm.trackedDays.append(DayVM(date: date, tracked: true))
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
        let result = repository.save(withName: name, color: color)
    }
}
