//
//  Auto+CoreDataProperties.swift
//  AutoTestingApp
//
//  Created by Stepan Ostapenko on 08.08.2023.
//
//

import Foundation
import CoreData


extension Auto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Auto> {
        return NSFetchRequest<Auto>(entityName: "Auto")
    }

    @NSManaged public var mark: String?
    @NSManaged public var distributor: String?
    @NSManaged public var power: Int16
    @NSManaged public var acceleration: Double
    @NSManaged private var driveTypeValue: Int16
    @NSManaged public var width: Int16
    @NSManaged public var height: Int16
    @NSManaged public var length: Int16
    @NSManaged public var price: Double

    var driveType: DriveType {
        get {
            return DriveType(rawValue: driveTypeValue) ?? .front
        }
        set {
            driveTypeValue = newValue.rawValue
        }
    }
    
}

extension Auto : Identifiable {

}
