//
//  HabbitsRepository.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 10.04.2025.
//

protocol HabbitsRepository {
    func save(withName name: String, color: HabbitColors) -> Result<Habbit, Error>
    func update(habbit: Habbit) -> Result<Habbit, Error>
    func delete(habbit: Habbit) -> Result<Void, Error>
    func fetchHabbits() -> Result<[Habbit], Error>
}
