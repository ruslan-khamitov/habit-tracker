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
    
    func fetchHabbits() -> [Habbit] {
        let fetchResult = repository.fetchHabbits()
        
        do {
            let result = try fetchResult.get()
            self.habbits = result
            
            return result
        } catch {
            // TODO: add warning
            
            return []
        }
    }
    
    func saveHabbit(withName name: String, andColor color: HabbitColors) {
        repository.save(withName: name, color: color)
    }
}
