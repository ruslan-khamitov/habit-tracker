//
//  HabitsRepository.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 10.04.2025.
//
import Foundation

protocol HabitsRepository {
    func create(withName name: String, color: HabbitColors) async -> Result<HabitEntity, Errors>
    func update(habit: HabitEntity) async -> Result<HabitEntity, Errors>
    func delete(byHabitId: UUID) async -> Result<Void, Errors>
    func fetchHabits() async -> Result<[HabitEntity], Errors>
    func fetch(byHabitId: UUID) async -> HabitEntity?
    
    func track(day: Date, forHabitId: UUID) async -> Result<HabitDay, Errors>
    func untrack(byTrackedDayId: UUID) async -> Result<Void, Errors>
}
