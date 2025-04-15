//
//  AppContainer.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 10.04.2025.
//

class AppContainer {
    static let habitsRepository: HabitsRepository = {
        return CoreDataHabitsRepository()
    }()
    
    static let habitsInteractor: HabitsInteractor = {
      return HabitsInteractor(repository: habitsRepository)
    }()
}
