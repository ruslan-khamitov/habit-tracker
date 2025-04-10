//
//  CoreDataHabbitsRepository.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 10.04.2025.
//
import CoreData
import UIKit

class CoreDataHabbitsRepository: HabbitsRepository {
    private let ctx = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func update(habbit: Habbit) -> Result<Habbit, any Error> {
        do {
            try ctx.save()
            
            return .success(habbit)
        } catch {
            return .failure(error)
        }
    }
    
    func delete(habbit: Habbit) -> Result<Void, any Error> {
        do {
            ctx.delete(habbit)
            
            try ctx.save()
            
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func fetchHabbits() -> Result<[Habbit], any Error> {
        do {
            let result = try ctx.fetch(Habbit.fetchRequest())
            
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
    
    func save(withName name: String, color: HabbitColors) -> Result<Habbit, any Error> {
        do {
            let habbit = Habbit(context: ctx)
            habbit.name = name
            habbit.color = color.rawValue
            
            try ctx.save()
            
            return .success(habbit)
        } catch {
            return .failure(error)
        }
    }
}
