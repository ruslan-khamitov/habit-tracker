//
//  CoreDataHabitsRepository.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 10.04.2025.
//
import CoreData
import UIKit


class CoreDataHabitsRepository: HabitsRepository {
    private let ctx: NSManagedObjectContext
    
    init(ctx: NSManagedObjectContext) {
        self.ctx = ctx
    }
    
    private func fetchCoreDataHabit(byHabitId id: UUID) -> Habit? {
        do {
            let request = Habit.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            request.fetchLimit = 1
            
            let results = try ctx.fetch(request)
            
            return results.first
        } catch {
            return nil
        }
    }
    
    func fetch(byHabitId id: UUID) async -> HabitEntity? {
        fetchCoreDataHabit(byHabitId: id)?.habitEntity
    }
    
    private func fetchOrCreate(byHabitId id: UUID) throws -> Habit {
        let fetched = fetchCoreDataHabit(byHabitId: id)
        if let existing = fetched {
            return existing
        }
        
        let newHabit = Habit()
        newHabit.id = id

        return newHabit
    }
    
    private func fetch(byTrackedDayId dayId: UUID) -> TrackedDay? {
        do {
            let request = TrackedDay.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", dayId as CVarArg)
            request.fetchLimit = 1
            
            let results = try ctx.fetch(request)
            
            return results.first
        } catch {
            return nil
        }
    }
    
    private func fetchOrCreate(byTrackedDayId dayId: UUID) throws -> TrackedDay {
        let fetched = fetch(byTrackedDayId: dayId)
        if let existing = fetched {
            return existing
        }
        
        let newTrackedDay = TrackedDay()
        newTrackedDay.id = dayId

        return newTrackedDay
    }
    
    func update(habit: HabitEntity) async -> Result<HabitEntity, Errors> {
        do {
            let habitToUpdate = fetchCoreDataHabit(byHabitId: habit.id)
            guard let habitToUpdate else {
                return .failure(.failedToFetchHabit)
            }
            
            habitToUpdate.name = habit.name
            habitToUpdate.color = habit.color.rawValue
            
            try await MainActor.run {
                try ctx.save()
            }
            
            return .success(habit)
        } catch {
            return .failure(.failedToUpdateHabit)
        }
    }
    
    func delete(byHabitId id: UUID) async -> Result<Void, Errors> {
        do {
            let habit = fetchCoreDataHabit(byHabitId: id)
            
            guard let habit else {
                return .success(())
            }
            
            ctx.delete(habit)
            
            try await MainActor.run {
                try ctx.save()
            }
            
            return .success(())
        } catch {
            return .failure(.failedToDeleteHabit)
        }
    }
    
    func fetchHabits() async -> Result<[HabitEntity], Errors> {
        do {
            let result = try await MainActor.run {
                try ctx.fetch(Habit.fetchRequest())
            }
            
            let habits =  result.compactMap({ $0.habitEntity })
            return .success(habits)
        } catch {
            return .failure(.failedToFetchHabit)
        }
    }
    
    func create(withName name: String, color: HabbitColors) async -> Result<HabitEntity, Errors> {
        do {
            let habit = Habit(context: ctx)
            let id = UUID()
            habit.name = name
            habit.color = color.rawValue
            habit.id = id
            
            try await MainActor.run {
                try ctx.save()
            }
            
            let entity = HabitEntity(id: id, name: name, color: color.rawValue)
            
            return .success(entity)
        } catch {
            return .failure(.failedToSaveHabit)
        }
    }
    
    func track(day: Date, forHabitId habitId: UUID) async -> Result<HabitDay, Errors> {
        do {
            let habit = fetchCoreDataHabit(byHabitId: habitId)
            guard let habit else {
                return .failure(.habitNotFound)
            }
            
            let dayId = UUID()
            
            let trackedDay = TrackedDay(context: ctx)
            trackedDay.habit = habit
            trackedDay.date = day
            trackedDay.id = dayId
            
            try await MainActor.run {
                try ctx.save()
            }
            
            let habitDay = HabitDay(id: dayId, date: day, isTracked: true)
            return .success(habitDay)
        } catch {
            return .failure(.failedToTrackDay)
        }
    }
    
    func untrack(byTrackedDayId dayId: UUID) async -> Result<Void, Errors> {
        do {
            let day = fetch(byTrackedDayId: dayId)
            guard let day else {
                return .success(())
            }
            
            ctx.delete(day)
            
            try await MainActor.run {
                try ctx.save()
            }
            
            return .success(())
        } catch {
            return .failure(.failedToUntrackDay)
        }
    }
}
