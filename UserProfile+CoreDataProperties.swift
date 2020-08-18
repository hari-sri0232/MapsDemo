//
//  UserProfile+CoreDataProperties.swift
//  MapsDemo
//
//  Created by Sri Hari on 17/08/20.
//  Copyright © 2020 Ojas. All rights reserved.
//
//

import Foundation
import CoreData


extension UserProfile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfile> {
        return NSFetchRequest<UserProfile>(entityName: "UserProfile")
    }

    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var trips: NSSet?

}

// MARK: Generated accessors for trips
extension UserProfile {

    @objc(addTripsObject:)
    @NSManaged public func addToTrips(_ value: Trips)

    @objc(removeTripsObject:)
    @NSManaged public func removeFromTrips(_ value: Trips)

    @objc(addTrips:)
    @NSManaged public func addToTrips(_ values: NSSet)

    @objc(removeTrips:)
    @NSManaged public func removeFromTrips(_ values: NSSet)

}
