//
//  Errors.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 11.04.2025.
//

enum Errors: String, Error {
    case failedToSaveHabit = "Failed to save habit"
    case failedToUpdateHabit = "Failed to update habit"
    case failedToDeleteHabit = "Failed to delete habit"
    case failedToFetchHabit = "Failed to fetch habit"
    case habitNotFound = "Habit not found"
    
    case failedToTrackDay = "Failed to track day"
    case failedToUntrackDay = "Failed to untrack day"
}
