import UIKit
import CoreLocation
import MapKit
import Contacts

class nearbyLandmarksVC: UIViewController {
    
    let menuButton = UIButton()

    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?{
            didSet {
                 performSearch("Store")
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBackground
        configureLocationManager()
        configureUI()

    }
    
    func configureUI(){
        
        configureButton()
        
    }
    
    func configureButton(){
        
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(menuButton)
        
        //add the target for the ab action that calls the function that performs the desired action of pushing the desired VC:
        
//        menuButton.addTarget(self, action: #selector(didTap), for: UIControl.Event.touchUpInside)
        
        menuButton.layer.cornerRadius = 10
                
        let menuImage = UIImage(named: "filterImage")
        
        menuButton.setImage(menuImage, for: .normal)
        
        menuButton.clipsToBounds = true // keeps image from rendering outside the button
        
        
        menuButton.menu = createMenu()
        
        menuButton.showsMenuAsPrimaryAction = true
        
        NSLayoutConstraint.activate([
            
            menuButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            menuButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            menuButton.heightAnchor.constraint(equalToConstant: 50),
            menuButton.widthAnchor.constraint(equalToConstant: 50) // we technically don't needs this, but it serves as padding to the content.
        ])
        
    }
    
    func createMenu()-> UIMenu{
        
        let actions = createActions()
        
        let menu = UIMenu(title: "Categories" , children: actions)
        
        return menu
    
    }
    
    func createActions() -> [UIAction]{
        
        
        
        let restaurantFilterAction  = UIAction(title: "Restaurant" , handler: { _ in self.didTap("Restaurant")})
        let cafeFilterAction = UIAction(title: "Cafe", handler: {_ in self.didTap("Cafe")})
        let foodFilterAction = UIAction(title: "Food Market", handler: {_ in self.didTap("Food Market")})
        let pharmacyFilterAction = UIAction(title: "Pharmacy", handler: {_ in self.didTap("Pharmacy")})
        let wineryFilterAction = UIAction(title: "Winery", handler: {_ in self.didTap("Winery")})
        let bakeryFilterAction = UIAction(title: "Bakery", handler: {_ in self.didTap("Bakery")})
        let defaultFilterAction  = UIAction(title: "Store (Default)" , handler: { _ in self.didTap("Store")})
        
        let menuItems : [UIAction] = [restaurantFilterAction,cafeFilterAction,foodFilterAction,pharmacyFilterAction,wineryFilterAction,bakeryFilterAction,defaultFilterAction]
        
        return menuItems
    }
    
    @objc func didTap(_ actionTitle : String){
        
        
        //        let dataToSend : String = "Sent Data"
        
        //        let nextVC = nearbyLandmarksVC()
        
        //        delegateProperty = nextVC
        
        //        delegateProperty?.sendData(dataToSend)
        
        //        navigationController?.pushViewController(nextVC, animated: true)
        
        print("*****New Search*****\n")
//
//        guard let tapQuery : String = button.titleLabel?.text
//        else{
//            print("Button titleLabel is nil")
//            return
//        }
        
        performSearch(actionTitle)
        
    }
        
}

extension nearbyLandmarksVC : CLLocationManagerDelegate{
    
    
    func configureLocationManager() {
        
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
                    
        }
    
    // The following checks whether the user changed the authorization of the app in order to start collecting the location information.
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                
                // This start collecting the location data. It creates a variable called "locations" which stores an array of locations ([CLLocation]);
                // It then passes this variable to the next location manager delegate function.
                
                locationManager.startUpdatingLocation()
            }
        }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last { // this allows us to get the lattest location of the user and pass it to our currentLocation variable.
                currentLocation = location
                locationManager.stopUpdatingLocation() // once we get their location, we stop gathering more info.
            }
        }
    
    func returnCat(_ selection : String) -> [MKPointOfInterestCategory]{
        
        var categories : [MKPointOfInterestCategory] = []
        
        switch selection{
            
        case "Bakery":
            
            categories.append(MKPointOfInterestCategory.bakery)
            return categories
            
        case "Brewery":
            
            categories.append(MKPointOfInterestCategory.brewery)
            return categories
            
        case "Cafe":
            
            categories.append(MKPointOfInterestCategory.cafe)
            return categories
            
        case "Food Market":
            
            categories.append(MKPointOfInterestCategory.foodMarket)
            return categories
            
        case "Pharmacy":
            
            categories.append(MKPointOfInterestCategory.pharmacy)
            return categories
            
        case "Restaurant":
            
            categories.append(MKPointOfInterestCategory.restaurant)
            return categories
            
        case "Store":
            
            categories.append(MKPointOfInterestCategory.store)
            return categories
            
        case "Winery":
            
            categories.append(MKPointOfInterestCategory.winery)
            return categories
        
        default:
            
            categories = [.bakery,.brewery,.cafe,.foodMarket,.pharmacy,.restaurant,.store,.winery]
            return categories
            
            
        }
        
        
    }
    
    func performSearch(_ query: String) {
        
        guard let location = currentLocation else {
            print("Current location is not available.")
            return
        }
        
        let request = MKLocalSearch.Request()
        
        request.naturalLanguageQuery = query

        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000) // these last two parameters specify the distance from the user we want to search for.
        
        request.region = region
        
        
        let search = MKLocalSearch(request: request)
        
        search.start { response, error in
                if let error = error {
                    print("Search error: \(error.localizedDescription)")
                    return
                }
                guard let response = response, !response.mapItems.isEmpty else {
                    print("No results were found.")
                    return
                }
            
            // Filtering mapItems and returning
            
            let categories = self.returnCat(query)
    
            
            let filteredItems = response.mapItems.filter { item in
                
                // .pointOfInterestCategory is a property of .mapItems; it returns false if it's set to nil for that particular item
                
                    guard let category = item.pointOfInterestCategory else { return false }
                
                // If it has a value, we assign it to the "category" variable and use it to check whether it's in our previously defined "categories"
                // array containing the categories we're looking for; it returns true if it is present in the array and added as an item to the
                // filteredItems array, which is our filtered version of mapItems.
                
                    return categories.contains(category)
                }
            
            // .placemark = object containing physical location information.
            
            for item in filteredItems {
                // Use CNPostalAddressFormatter to format the address into a single string
                if let postalAddress = item.placemark.postalAddress {
                    let formattedAddress = CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress)
                    
              // add a condtion here that checks for irrelevant categories and skips to the next item if true.
                    
                    print("Name: \(item.name ?? "No name") , \nCategory: \(item.pointOfInterestCategory?.rawValue ?? "Unknown Category"), \nAddress:\(formattedAddress)\n") // rawValue = A string that represents the point of interest category.
                } else {
                    // Fallback in case postalAddress is nil
                    print("Name: \(item.name ?? "No name"), Location: \(item.placemark.coordinate)")
                }
            }
        }
    }

}
