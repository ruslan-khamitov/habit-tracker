//
//  HabdsitsInteractor.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 10.04.2025.
//
import Foundation
import Combine

class HabitsInteractor: ObservableObject {
    private let repository: HabitsRepository
    
    @Published var habits: [HabitVM] = []
    
    init(repository: HabitsRepository) {
        self.repository = repository
    }
    
    func fetchHabits() async -> Void {
        let fetchResult = await repository.fetchHabits()
        
        do {
            let result: [Habit] = try fetchResult.get()
            
            self.habits = result.compactMap { HabitHelper.parseHabitVMfromCoreData($0) }
        } catch {
            // TODO: add handling
        }
    }
    
    func saveHabit(withName name: String, andColor color: HabbitColors) async {
        let saveResult = await repository.save(withName: name, color: color)
        do {
            let savedHabit = try saveResult.get()
            let habit = HabitHelper.parseHabitVMfromCoreData(savedHabit)
            guard let habit = habit else {
                return
            }
            habits.append(habit)
        } catch {
            // TODO: add handling
        }
    }
    
    func refetchHabit(habit: HabitVM) async -> HabitVM? {
        let fetchResult = await repository.fetch(byHabitId: habit.id)
        
        guard let fetchedHabit = fetchResult else {
            return nil
        }
        
        guard let parsedHabit = HabitHelper.parseHabitVMfromCoreData(fetchedHabit) else {
            return nil
        }
        
        let index = self.habits.firstIndex { habit in
            habit.id == fetchedHabit.id
        }
        if let index = index {
            self.habits[index] = parsedHabit
        }
        
        return parsedHabit
    }
    
    func remove(habit: HabitVM) async {
        let result = await repository.delete(byHabitId: habit.id)
        result.onSuccess {
            self.habits = self.habits
                .filter {
                    $0.id != habit.id
                }
        }
    }
    
    // Tracking days
    private func track(day: DayVM, forHabit habit: HabitVM) async {
        let dateToTrack = day.getStartOfDay()
        _ = await repository.track(day: dateToTrack, forHabitId: habit.id)
    }
    
    private func untrack(day: DayVM) async {
        _ = await repository.untrack(byTrackedDayId: day.id)
    }
    
    func toggleTrack(day: DayVM, forHabit habit: HabitVM) async {
        let toggleDate = day.getStartOfDay()
        
        let trackedDay = habit.trackedDays.first { $0.date == toggleDate }
        if let trackedDay {
            await untrack(day: trackedDay)
            return
        }
        
        await track(day: day, forHabit: habit)
    }
}
