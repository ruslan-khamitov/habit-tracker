//
//  AppContainer.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 10.04.2025.
//

class AppContainer {
    static let habbitsRepository: HabbitsRepository = {
        return CoreDataHabbitsRepository()
    }()
    
    static let habbitsInteractor: HabbitsInteractor = {
      return HabbitsInteractor(repository: habbitsRepository)
    }()
}
