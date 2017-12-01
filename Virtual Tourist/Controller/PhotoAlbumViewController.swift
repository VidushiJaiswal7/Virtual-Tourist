//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by VIdushi Jaiswal on 15/11/17.
//  Copyright © 2017 Vidushi Jaiswal. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController, NSFetchedResultsControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // CoreData properties
    public var stack: CoreDataStack {
        get {
            let app = UIApplication.shared.delegate as! AppDelegate
            return app.stack
        }
    }
    
    public var context: NSManagedObjectContext {
        get {
            return stack.context
        }
    }
    //Keeping track of insertions and deletions
    var insertedIndexPaths: [IndexPath]!
    var deletedIndexPaths : [IndexPath]!
    var updatedIndexPaths : [IndexPath]!
    
    //MARK: Properties
    @IBOutlet weak var photoVCMapView: MKMapView!
    @IBOutlet weak var albumCollectionView: UICollectionView!
    @IBOutlet weak var newCollectionButton: UIButton!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var location: LocationPin!
    var fetchedResultsController: NSFetchedResultsController<Photo>!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("The tapped location is\(location)")
        //print("Latitude \(location.coordinate.latitude)")
        //print("Longitude \(location.coordinate.longitude)")
        
        //a)Set up the Map
        let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2))
        photoVCMapView.setRegion(region, animated: true)
        photoVCMapView.addAnnotation(location)
        
        
        //Reference - took help from in-class CoolNotes app
        // b)Create the fetch request
        let photoFetch: NSFetchRequest<Photo> = Photo.fetchRequest()
        //To filter the results based on location
        photoFetch.predicate = NSPredicate(format: "photoToPin == %@", self.location)
        photoFetch.sortDescriptors = []
    
        //Reference - took help from in-class CoolNotes app
        //c)Create the FetchedResultsController
        fetchedResultsController = NSFetchedResultsController(fetchRequest: photoFetch, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        //d)Download Images to display in collection view
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error")
        }
        self.downloadImages()
        
        //e)Setting the flowLayout of the cells
        let space:CGFloat = 2.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: 80, height: 100)
        
    }

    //MARK: Helper functions
    //TODO: Create a function for downloading images
    func downloadImages() {
      
        self.getPhotos(location: location, completionHandler: {(photos, error) in
            
            /* Was there an error with the request? */
            guard error == nil else {
                self.alertUser("Error", (error?.localizedDescription)!)
                print("There was an error with the request \(String(describing: error))")
               return
            }

            /* Was any data returned? */
            if photos?.count == 0  {
                self.alertUser("No photos found", "Try again!")
                print("No data returned")
            }
        })
    }
    
    //Function to get urls of images
    //Reference - StackOverflow
     func getPhotos(location: LocationPin, completionHandler: @escaping ([Photo]?, Error?) -> Void) {
        
        FlickrClient.searchByLatLon(location: location, completionHandler: {(results, error) in
            guard error == nil else {
                print("Error in request")
                return
            }
            
            
            performUIUpdatesOnMain {
                var photos = [Photo]()
                for result in results! {
                    if let urlString = result[Constants.FlickrParameterValues.MediumURL],
                        let imageURL = URL(string: urlString as! String)  {
                        let photo = Photo(url: imageURL, location: location, context: self.context)
                        photos.append(photo)
                    }
                }
                completionHandler(photos, nil)
            }
        })
    }
    
    //Function to alert the user
    func alertUser(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: NSFetchedResultsControllerDelegate functions
    //Reference - Code based on in-class CoolNotes app
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexPaths = [IndexPath]()
        deletedIndexPaths  = [IndexPath]()
        updatedIndexPaths  = [IndexPath]()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
      
        switch type {
        case .insert:
            //print("Inserting")
            insertedIndexPaths.append(newIndexPath!)
            break
        case .update:
            //print("Updating")
            updatedIndexPaths.append(indexPath!)
            break
        case .delete:
            //print("Deleting")
            deletedIndexPaths.append(indexPath!)
            break
        default:
            //irrevelent case
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        albumCollectionView.performBatchUpdates({
            for indexPath in self.insertedIndexPaths {
                self.albumCollectionView.insertItems(at: [indexPath])
            }
            for indexPath in self.deletedIndexPaths {
                self.albumCollectionView.deleteItems(at: [indexPath])
            }
            for indexPath in self.updatedIndexPaths {
                self.albumCollectionView.reloadItems(at: [indexPath])
            }
        }, completion: nil)
    }
    

    //MARK: UICollectionViewDataSource functions
    //i. To get the number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (fetchedResultsController.fetchedObjects?.count)!
    }
    
    //ii. To display the image in the cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoAlbumCollectionViewCell
        let photo = fetchedResultsController.object(at: indexPath)
        
        if let imgData = photo.image {
            let img = UIImage(data: imgData as Data)
            cell.imageView.image = img
        } else {
            //Setting the placeholder image
            cell.imageView.image = #imageLiteral(resourceName: "placeholder")
            FlickrImageDownloader.downloadPhoto(photo)
        }
        
        return cell
        
    }
    //iii. For deleting when the cell is tapped
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = fetchedResultsController.object(at: indexPath)
        self.context.delete(photo)
        do {
            try stack.saveContext()
        } catch {
            fatalError("Could not Save")
        }
    }
    
    //MARK: Actions
    //Replacing the existing collection with a new one
  @IBAction func newCollection(_ sender: Any) {
       
        if let photos = fetchedResultsController.fetchedObjects {
            for photo in photos {
                self.context.delete(photo)
            }
            do {
                try stack.saveContext()
            } catch {
                fatalError("Could not Save")
            }
        }
       
        downloadImages()
    }
    
}
