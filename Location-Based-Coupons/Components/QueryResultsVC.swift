
import UIKit
import CoreLocation
import MapKit
import Contacts
import Foundation

//randomly generates date between two dates
extension Date {
    
    static func randomBetween(start: String, end: String, format: String = "yyyy-MM-dd") -> String {
        let date1 = Date.parse(start, format: format)
        let date2 = Date.parse(end, format: format)
        return Date.randomBetween(start: date1, end: date2).dateString(format)
    }

    static func randomBetween(start: Date, end: Date) -> Date {

    // - - - - - - - - - - - - CHANGES START HERE - - - - - - - - - - - - //
        let date1 = min(start, end)
        var date2 = max(start, end)
        
        if date1 == date2 {
            date2 = date1.addingTimeInterval(120)
        }
    // - - - - - - - - - - - - CHANGES END HERE - - - - - - - - - - - - //

        let span = TimeInterval.random(in: date1.timeIntervalSinceNow...date2.timeIntervalSinceNow)
        return Date(timeIntervalSinceNow: span)
    }

    func dateString(_ format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

    static func parse(_ string: String, format: String = "yyyy-MM-dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.dateFormat = format

        let date = dateFormatter.date(from: string)!
        return date
    }
}
class QueryResultsVC: UIViewController {
    
    // Location manager to handle location services
    let locationManager = CLLocationManager()
    
    // Variable to store the user's current location
    var currentLocation: CLLocation? {
        didSet {
            performSearch(for: "coffee") // Implement the category property to safeguard against situations that make no sense.
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set background color for the view
        view.backgroundColor = UIColor.systemYellow
        
        // Configure the location manager
        configureLocationManager()
    }
    
    // Function to configure the location manager
    func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
}

// Extension to handle location manager delegate methods
extension QueryResultsVC: CLLocationManagerDelegate {
    
    // Function to handle changes in location authorization status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Check if the app is authorized to use location services
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            // Start updating the location
            locationManager.startUpdatingLocation()
        }
    }

    // Function to handle location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Get the latest location
        if let location = locations.last {
            // Update the current location
            currentLocation = location
            // Stop updating the location once we have it
            locationManager.stopUpdatingLocation()
        }
    }
    
    // Function to perform search based on the provided query
    func performSearch(for query: String) {
        
        // Check if the current location is available
        guard let location = currentLocation else {
            print("Current location is not available.")
            return
        }
        
        // Create a search request
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        // Set the search region based on the current location
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        request.region = region
        
        // Perform the search
        let search = MKLocalSearch(request: request)
        
        search.start { response, error in
            guard let response = response else {
                print("Search error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            // Define the categories we are interested in
            let categories = [MKPointOfInterestCategory.cafe, .bakery]
            
            // Filter the search results based on the categories
            let filteredItems = response.mapItems.filter { item in
                guard let category = item.pointOfInterestCategory else { return false }
                return categories.contains(category)
            }
            
            let date1 = "2024-04-10"
            let date2 = "2024-05-10"
            // Iterate through the filtered items
            for item in filteredItems {
                // Format the address
                if let postalAddress = item.placemark.postalAddress {
                    let formattedAddress = CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress)
                    
                    // Calculate the distance to the store from the user's current location in miles
                    let storeLocation = CLLocation(latitude: item.placemark.coordinate.latitude, longitude: item.placemark.coordinate.longitude)
                    let userLocation = self.currentLocation!
                    let distance = userLocation.distance(from: storeLocation) / 1609.34
                    
                    // Generate a random coupon code
                    let couponCode = self.generateRandomCouponCode(length: 10)
                    
                    let date = Date.randomBetween(start: date1, end:date2)
                    // Print the store details
                    print("""
                        Name: \(item.name ?? "No name"),
                        Category: \(item.pointOfInterestCategory?.rawValue ?? "Unknown Category"),
                        Address: \(formattedAddress),
                        Until: \(date),
                        Distance: \(String(format: "%.2f", distance)) miles,
                        Coupon Code: \(couponCode)
                        """)
                    
                } else {
                    // Print the store details without address
                    print("Name: \(item.name ?? "No name"), Location: \(item.placemark.coordinate)")
                }
            }
        }
    }
    
    // Function to generate a random coupon code
    func generateRandomCouponCode(length: Int) -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
    
    
}
