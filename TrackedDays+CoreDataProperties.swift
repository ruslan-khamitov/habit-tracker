//
//  TrackedDays+CoreDataProperties.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 14.04.2025.
//
//

import Foundation
import CoreData


extension TrackedDays {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackedDays> {
        return NSFetchRequest<TrackedDays>(entityName: "TrackedDays")
    }

    @NSManaged public var date: Date?
    @NSManaged public var habit: Habit?

}

extension TrackedDays : Identifiable {

}
