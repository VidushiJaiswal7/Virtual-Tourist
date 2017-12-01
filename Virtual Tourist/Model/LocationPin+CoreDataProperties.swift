//
//  LocationPin+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by VIdushi Jaiswal on 13/11/17.
//  Copyright © 2017 Vidushi Jaiswal. All rights reserved.
//
//

import Foundation
import CoreData


extension LocationPin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationPin> {
        return NSFetchRequest<LocationPin>(entityName: "LocationPin")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var pinToPhoto: NSSet?

}

// MARK: Generated accessors for pinToPhoto
extension LocationPin {

    @objc(addPinToPhotoObject:)
    @NSManaged public func addToPinToPhoto(_ value: Photo)

    @objc(removePinToPhotoObject:)
    @NSManaged public func removeFromPinToPhoto(_ value: Photo)

    @objc(addPinToPhoto:)
    @NSManaged public func addToPinToPhoto(_ values: NSSet)

    @objc(removePinToPhoto:)
    @NSManaged public func removeFromPinToPhoto(_ values: NSSet)

}
