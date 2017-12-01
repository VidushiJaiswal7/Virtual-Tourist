//
//  FlickrImageDownloader.swift
//  Virtual Tourist
//
//  Created by VIdushi Jaiswal on 16/11/17.
//  Copyright © 2017 Vidushi Jaiswal. All rights reserved.
//



//Separate class to download images from Flickr
import Foundation
import UIKit
import CoreData

class FlickrImageDownloader: NSObject {
    
    // CoreData properties
    static var stack: CoreDataStack {
        get {
            let app = UIApplication.shared.delegate as! AppDelegate
            return app.stack
        }
    }
    
    static var context: NSManagedObjectContext {
        get {
            return stack.context
        }
    }
    
    //Download Image - Saving the Photo's data property
    
    class func downloadPhoto( _ photo: Photo) {
        
        let url = photo.url!
     downloadImage(imageURL: url, completionHandler: {(data,error) in
        performUIUpdatesOnMain {
            photo.image = data as NSData?
            do {
                try self.stack.saveContext()
            } catch {
                fatalError("Could not Save Image Data")
            }
        }
     })

        
    }
    
    //Reference - Code given by the code reviewer
    class func downloadImage( imageURL:URL, completionHandler: @escaping (_ imageData: Data?, _ errorString: String?) -> Void){
        let session = URLSession.shared
        //let imgURL = NSURL(string: imagePath)
        let request: NSURLRequest = NSURLRequest(url: imageURL as URL)
        
        let task = session.dataTask(with: request as URLRequest) {data, response, downloadError in
            
            if downloadError != nil {
                completionHandler(nil, "Could not download image \(imageURL)")
            } else {
                
                completionHandler(data, nil)
            }
        }
        
        task.resume()
    }
    
   
}

