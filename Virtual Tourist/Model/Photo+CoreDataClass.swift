//
//  Photo+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by VIdushi Jaiswal on 13/11/17.
//  Copyright © 2017 Vidushi Jaiswal. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Photo)
public class Photo: NSManagedObject {

    convenience init(url: URL, location: LocationPin, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Photo", in: context) {
            self.init(entity: ent, insertInto: context)
            self.url = url
            self.photoToPin = location
        } else {
            fatalError("Unable to find Entity name!")
        }
    }

}
