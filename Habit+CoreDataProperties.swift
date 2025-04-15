//
//  Habit+CoreDataProperties.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 14.04.2025.
//
//

import Foundation
import CoreData


extension Habit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit")
    }

    @NSManaged public var color: String?
    @NSManaged public var name: String?
    @NSManaged public var tracked: NSSet?

}

// MARK: Generated accessors for tracked
extension Habit {

    @objc(addTrackedObject:)
    @NSManaged public func addToTracked(_ value: TrackedDays)

    @objc(removeTrackedObject:)
    @NSManaged public func removeFromTracked(_ value: TrackedDays)

    @objc(addTracked:)
    @NSManaged public func addToTracked(_ values: NSSet)

    @objc(removeTracked:)
    @NSManaged public func removeFromTracked(_ values: NSSet)

}

extension Habit : Identifiable {

}
