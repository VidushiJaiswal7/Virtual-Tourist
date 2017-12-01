//
//  Photo+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by VIdushi Jaiswal on 13/11/17.
//  Copyright © 2017 Vidushi Jaiswal. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var image: NSData?
    @NSManaged public var url: URL?
    @NSManaged public var photoToPin: LocationPin?

}
