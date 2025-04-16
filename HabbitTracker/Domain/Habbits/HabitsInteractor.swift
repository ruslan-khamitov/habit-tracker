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
    
    @Published var habits: [HabitEntity] = []
    
    init(repository: HabitsRepository) {
        self.repository = repository
    }
    
    func fetchHabits() async -> Void {
        let fetchResult = await repository.fetchHabits()
        
        do {
            habits = try fetchResult.get()
        } catch {
            // TODO: add handling
        }
    }
    
    func createHabit(withName name: String, andColor color: HabbitColors) async {
        let saveResult = await repository.create(withName: name, color: color)
        do {
            let habit = try saveResult.get()
            habits.append(habit)
        } catch {
            // TODO: add handling
        }
    }
    
    func updateHabit(habit: HabitEntity) async -> Void {
        _ = await repository.update(habit: habit)
    }
    
    func refetchHabit(habit: HabitEntity) async -> HabitEntity? {
        let fetchedHabit = await repository.fetch(byHabitId: habit.id)
        guard let fetchedHabit else {
            return nil
        }
    
        if let index = habits.firstIndex(where: { $0.id == fetchedHabit.id }) {
            self.habits[index] = fetchedHabit
        }
        
        return fetchedHabit
    }
    
    func remove(habit: HabitEntity) async {
        let result = await repository.delete(byHabitId: habit.id)
        result.onSuccess {
            self.habits = self.habits
                .filter {
                    $0.id != habit.id
                }
        }
    }
    
    // Tracking days
    private func track(day: HabitDay, forHabit habit: HabitEntity) async {
        let dateToTrack = day.getStartOfDay()
        _ = await repository.track(day: dateToTrack, forHabitId: habit.id)
    }
    
    private func untrack(day: HabitDay) async {
        _ = await repository.untrack(byTrackedDayId: day.id)
    }
    
    func toggleTrack(day: HabitDay, forHabit habit: HabitEntity) async {
        let toggleDate = day.getStartOfDay()
        
        let trackedDay = habit.trackedDays.first { $0.date == toggleDate }
        if let trackedDay {
            await untrack(day: trackedDay)
            return
        }
        
        await track(day: day, forHabit: habit)
    }
}
