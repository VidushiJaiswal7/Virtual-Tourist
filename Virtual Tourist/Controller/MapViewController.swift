//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by VIdushi Jaiswal on 13/11/17.
//  Copyright © 2017 Vidushi Jaiswal. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate {

    //MARK: Properties
    @IBOutlet weak var mapView: MKMapView!
    
    var totalPins : [LocationPin] = []
    var tappedPin : LocationPin!
    var newPin : LocationPin!
    
    
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
    
    
    private var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
       //a) Set the delegates
        mapView.delegate = self
        
        //b) Add the hold and press gesture
        //Reference - Stackoverflow
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(addNewPin))
        longPressGesture.minimumPressDuration = 0.5
        self.mapView.addGestureRecognizer(longPressGesture)
     
        //c) Restore the mapDefaults - region and zoom level
        retrieveDefaults()
        
        //d) Get stored LocationPins from Core Data
        getExistingPins()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Hide the navigation bar
        self.navigationController?.isNavigationBarHidden = true
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Show the navigation bar
        self.navigationController?.isNavigationBarHidden = false

    }
    //Reference - Stackoverflow
    override var prefersStatusBarHidden: Bool {
        return true
    }
  
    //  e) MKMapViewDelegate functions
    //TODO:  e) i. didSelectAnnoation (MKMapViewDelegate) - to perform the segue
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? LocationPin {
            tappedPin = annotation
            self.performSegue(withIdentifier: "PhotoAlbumVC", sender: nil)
        }
    }
    
    //e) ii. regionDidChange (MKMapViewDelegate) - to save the region
    //Reference - StackOverflow
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //print("Region Changed!")
        saveDefaults()
    }

    //Sending the location of the Tapped Pin
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PhotoAlbumVC" {
            let vc = segue.destination as! PhotoAlbumViewController
            vc.location = tappedPin
        }
    }
    
    //MARK: Helper functions
    //Making the region and zoon level of the map persistent
    //Refernce - Based on in class app - PickYourPitch
    func saveDefaults() {
        let latitude = mapView.region.center.latitude
        let longitude = mapView.region.center.longitude

        let latitudeSpan = mapView.region.span.latitudeDelta
        let longitudeSpan = mapView.region.span.longitudeDelta
   
        let mapDefaults = [latitude, longitude, latitudeSpan, longitudeSpan]
        
        //Save
        UserDefaults.standard.set(mapDefaults, forKey: "MapDefaults")

    }
    
    //Retrieving the saved MapRegion and zoom level defaults
    func retrieveDefaults() {
        
        if let mapDefaults = UserDefaults.standard.array(forKey: "MapDefaults") {
            let region = CLLocationCoordinate2D(latitude: mapDefaults[0] as! CLLocationDegrees, longitude: mapDefaults[1] as! CLLocationDegrees)
          let zoomLevel = MKCoordinateSpan(latitudeDelta: mapDefaults[2] as! CLLocationDegrees, longitudeDelta: mapDefaults[3] as! CLLocationDegrees)
        
        
          let savedRegion = MKCoordinateRegion(center: region, span: zoomLevel)
           print(savedRegion)
        
        mapView.setRegion(savedRegion, animated: true)
        }
    }

    
    //Adding pin when longpress gesture detected
    @objc func addNewPin(sender : UIGestureRecognizer){
        //print("Add new Pin. Longpress detected")
 
        //Reference - Stackoverflow
        //Suggested by the code reviewer
        if sender.state == UIGestureRecognizerState.began {
            //Pin will be created
            //print("Began")
            let touchLocation = sender.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            newPin = LocationPin(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude, context: stack.context)
        
            mapView.addAnnotation(newPin)
            //print(newPin)
        }
        
        if sender.state == UIGestureRecognizerState.changed {
            //Updating the pin coordinates
           // print("Changed")
            let touchLocation = sender.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            newPin.latitude = locationCoordinate.latitude
            newPin.longitude = locationCoordinate.longitude
            //print(newPin)
            
        }
        
        if sender.state == UIGestureRecognizerState.ended {
            //Removing the old pin and adding the new updated pin
            mapView.removeAnnotation(newPin)
            //print("End")
            //print(newPin)
            mapView.addAnnotation(newPin)
            
            //Save the pin to core data
            do {
                try stack.saveContext()
            } catch {
                fatalError("Could not Save")
            }
        }
 
        }
        
        
       
        
    
    //Fetching the already saved pins - and displaying them on the map
    func getExistingPins() {
        let request: NSFetchRequest<LocationPin> = LocationPin.fetchRequest()
        do {
            let locationPins  = try stack.context.fetch(request)
            for locationPin in locationPins {
                //Display the pins on the mapView
                mapView.addAnnotation(locationPin)
            }
        } catch {
            print("Error in fetching pins")
        }
    }

}

    



