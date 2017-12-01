//
//  LocationPin+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by VIdushi Jaiswal on 13/11/17.
//  Copyright © 2017 Vidushi Jaiswal. All rights reserved.
//
//

import Foundation
import CoreData
import MapKit

@objc(LocationPin)
public class LocationPin: NSManagedObject, MKAnnotation {
  
    public var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }

    convenience init(latitude: Double, longitude: Double, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "LocationPin", in: context) {
            self.init(entity: ent, insertInto: context)
            
            self.latitude = latitude
            self.longitude = longitude
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
    
    
    
}
