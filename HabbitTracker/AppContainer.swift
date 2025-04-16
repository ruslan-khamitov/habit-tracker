//
//  AppContainer.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 10.04.2025.
//
import UIKit

class AppContainer {
    static let habitsRepository: HabitsRepository = {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return CoreDataHabitsRepository(ctx: context)
    }()
    
    static let habitsInteractor: HabitsInteractor = {
      return HabitsInteractor(repository: habitsRepository)
    }()
}
