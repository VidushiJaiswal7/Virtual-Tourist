# Summary
This application was created specifically for Udacity's iOS Developer Nanodegree. The Virtual Tourist app downloads and stores images from Flickr. The app allows users to drop pins on a map, as if they were stops on a tour. Users will then be able to download pictures for the location and persist both the pictures, and the association of the pictures with the pin

# Technologies Used
Stack View
Auto Layout
UIKit
Swift
Text Field Delegate
MapKit
CoreLocation
JSON data.
API's
Navigation/Tab Bar Controllers
Grand Central Dispatch
UICollectionViews
MVC
Extensions
Core Data
NSUserDefaults

# User Interface
Virtual Tourist has two main view controllers :

MapViewController: When the app first starts it will open to the map view. Users will be able to zoom and scroll around the map using standard pinch and drag gestures.The center of the map and the zoom level is persistent. If the app is turned off, the map should return to the same state when it is turned on again.Tapping and holding the map drops a new pin.The user can drag the pin they have just dropped on the map, but only until they lift their finger.Users can place any number of pins on the map.When a pin is tapped, the app will navigate to the Photo Album view associated with the pin.

PhotoAlbumViewController: If the user taps a pin that does not yet have a photo album, the app will download Flickr images associated with the latitude and longitude of the pin.The images will be displayed in a collection view. A New Collection button is also provided. Tapping this button should empty the photo album and fetch a new set of images.

# Conclusion
In conclusion, I have learned a lot by working on this project. I learned using NSURLSessions to interact with a public restful API, create a user interface that intuitively communicates network activity and download progress, store media on the device file system Use Core Data for local persistence of an object structure



