
import SwiftUI
import UIKit
import CoreLocation
import MapKit
import Contacts





// Creating the model that accepts the landmark data from our search and is used to populate the UITableView

struct Landmark{
    
    var name : String
    
    var address : String
    
}


class nearbyLandmarksVC: UIViewController {
    
    let menuButton = UIButton()
    let profileButton = UIButton()
    let table = UITableView()
    var landmarks : [Landmark] = []
    let currentCatLabel = UILabel()

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
        
        configureProfileButton()
        configureMenuButton()
        configureCurrentCatLabel()
        configureTableView()
        
    }
    
    func configureMenuButton(){
        
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(menuButton)
        
        menuButton.layer.cornerRadius = 10
                
        let menuImage = UIImage(named: "filterImage")
        
        menuButton.setImage(menuImage, for: .normal)
        
        menuButton.clipsToBounds = true // keeps image from rendering outside the button
        
        menuButton.menu = createMenu()
        
        menuButton.showsMenuAsPrimaryAction = true // Allows the pop up menu to display when the button is selected.
        
        NSLayoutConstraint.activate([
            
            menuButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            menuButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            menuButton.heightAnchor.constraint(equalToConstant: 50),
            menuButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    func configureProfileButton(){
        
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(profileButton)
        
        profileButton.setTitle("Edit Profile", for: .normal)
        profileButton.setTitleColor(UIColor.systemBlue, for: .normal) // Won't display if no color is defined

        profileButton.titleLabel?.font = UIFont.systemFont(ofSize: 16 , weight: UIFont.Weight.bold)


                        
        NSLayoutConstraint.activate([
            
            profileButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            profileButton.heightAnchor.constraint(equalToConstant: 50),
            profileButton.widthAnchor.constraint(equalToConstant: 100)
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
    
    @objc func didTap(_ categoryType : String){
        
        performSearch(categoryType)
        
    }
    
    func configureCurrentCatLabel(){
        
        view.addSubview(currentCatLabel)
        currentCatLabel.translatesAutoresizingMaskIntoConstraints = false
        currentCatLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        currentCatLabel.textAlignment = .center

        
        NSLayoutConstraint.activate([
        
            currentCatLabel.topAnchor.constraint(equalTo: menuButton.bottomAnchor),
            currentCatLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentCatLabel.heightAnchor.constraint(equalToConstant: 50),
            currentCatLabel.widthAnchor.constraint(equalToConstant: 350)
        
        ])
        
    }
    
    
    func configureTableView(){
        
        view.addSubview(table)
        
        table.translatesAutoresizingMaskIntoConstraints = false
        
        table.delegate = self
        table.dataSource = self
        
        table.register(SelectableTextCell.self, forCellReuseIdentifier: "SelectableTextCell")
        
        table.estimatedRowHeight = 44
                table.rowHeight = UITableView.automaticDimension

        NSLayoutConstraint.activate([
            
           table.topAnchor.constraint(equalTo: currentCatLabel.bottomAnchor),
           table.leftAnchor.constraint(equalTo: view.leftAnchor),
           table.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           table.rightAnchor.constraint(equalTo: view.rightAnchor)
        
        ])
        
        
    }
    
}

class SelectableTextCell: UITableViewCell {
    
    let textView = UITextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureTextView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTextView() {
        
        contentView.addSubview(textView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.textColor = UIColor.black
        textView.backgroundColor = UIColor.systemBackground
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.dataDetectorTypes = []
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
    }
}

extension nearbyLandmarksVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return landmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SelectableTextCell", for: indexPath) as? SelectableTextCell {
            let landmark = landmarks[indexPath.row] // instantiating a landmark so we can populate the corresponding cell with the desired data.
            cell.textView.text = landmark.name + "\n" + landmark.address
            cell.textLabel?.numberOfLines = 0 // Allow multi-line text
            return cell
        } else {
            fatalError("Failed to dequeue SelectableTextCell")
        }
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
        currentCatLabel.text = "\(query) Coupons"
        
        guard let location = currentLocation else {
            print("Current location is not available.")
            return
        }
        
        let request = MKLocalSearch.Request()
        
        request.naturalLanguageQuery = query

        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000) // these last two parameters specify the distance from the user we want to search for.
        
        request.region = region
        
        
        let search = MKLocalSearch(request: request)
        
//casting response as a weak reference so that we can deallocate the VC even when data is being fetched for the response object:
        
           search.start { [weak self] response, error in
               guard let strongSelf = self else { return }// guards against self = nil and creates a reference to self called strongSelf.
               if let error = error {
                   print("Search error: \(error.localizedDescription)")
                   return
               }
               guard let response = response, !response.mapItems.isEmpty else {
                   print("No results were found.")
                   return
               }
            
            // Filtering mapItems and returning
            
            let categories = strongSelf.returnCat(query)
    
            
            let filteredItems = response.mapItems.filter { item in
                
                // .pointOfInterestCategory is a property of .mapItems; it returns false if it's set to nil for that particular item
                
                    guard let category = item.pointOfInterestCategory else { return false }
                
                // If it has a value, we assign it to the "category" variable and use it to check whether it's in our previously defined "categories"
                // array containing the categories we're looking for; it returns true if it is present in the array and added as an item to the
                // filteredItems array, which is our filtered version of mapItems.
                
                    return categories.contains(category)
                }
               
               strongSelf.landmarks.removeAll() // clearing all the old items from the model instance so that we only load the table with new data.

            
            // .placemark = object containing physical location information.
            
            for item in filteredItems {
                // Use CNPostalAddressFormatter to format the address into a single string
                if let postalAddress = item.placemark.postalAddress {
                    let formattedAddress = CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress)
                    
                    let landmark = Landmark(name : item.name ?? "no name" , address: formattedAddress)
                    
                    strongSelf.landmarks.append(landmark)
                    
                }
            }
            
            strongSelf.table.reloadData() // reload all visible data in table view.
        }
    }

}
