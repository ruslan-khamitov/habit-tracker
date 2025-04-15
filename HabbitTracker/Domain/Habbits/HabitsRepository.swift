//
//  HabitsRepository.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 10.04.2025.
//
import Foundation

protocol HabitsRepository {
    func save(withName name: String, color: HabbitColors) async -> Result<Habit, Errors>
    func update(habit: Habit) async -> Result<Habit, Errors>
    func delete(byHabitId: UUID) async -> Result<Void, Errors>
    func fetchHabits() async -> Result<[Habit], Errors>
    func fetch(byHabitId: UUID) async -> Habit?
    
    func track(day: Date, forHabitId: UUID) async -> Result<TrackedDay, Errors>
    func untrack(byTrackedDayId: UUID) async -> Result<Void, Errors>
}
