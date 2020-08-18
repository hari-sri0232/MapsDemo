//
//  Trips+CoreDataProperties.swift
//  MapsDemo
//
//  Created by Sri Hari on 17/08/20.
//  Copyright © 2020 Ojas. All rights reserved.
//
//

import Foundation
import CoreData


extension Trips {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trips> {
        return NSFetchRequest<Trips>(entityName: "Trips")
    }

    @NSManaged public var sName: String?
    @NSManaged public var sLat: Double
    @NSManaged public var sLong: Double
    @NSManaged public var dName: String?
    @NSManaged public var dLat: Double
    @NSManaged public var dLong: Double
    @NSManaged public var sAddress: String?
    @NSManaged public var dAddress: String?
    @NSManaged public var routes: Data?
    @NSManaged public var isTripEnded: Bool
    @NSManaged public var profile: UserProfile?

}
