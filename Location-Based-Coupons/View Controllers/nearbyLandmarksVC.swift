//Comment Check
import SwiftUI
import UIKit
import CoreLocation
import MapKit
import Contacts
import Firebase
import FirebaseCore

struct Landmark: Hashable {
    var name: String
    var address: String
}

struct coupon{
    var code: String
    var desc: String
    var date: String
}


class nearbyLandmarksVC: UIViewController {
    
    let menuButton = UIButton()
    let profileButton = UIButton()
    let table = UITableView()
    var landmarks: [Landmark] = []
    let currentCatLabel = UILabel()
    var landmarkDiscounts: [Landmark: (date:String, discount: String, couponCode: String)] = [:]
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation? {
        didSet {
            performSearch("Store")
        }
    }
    let currentDate = Date()
    let formatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        configureLocationManager()
        configureUI()
    }
    
    func configureUI() {
        configureProfileButton()
        configureMenuButton()
        configureCurrentCatLabel()
        configureTableView()
    }
    
    func configureMenuButton() {
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuButton)
        menuButton.layer.cornerRadius = 10
        let menuImage = UIImage(named: "filterImage")
        menuButton.setImage(menuImage, for: .normal)
        menuButton.clipsToBounds = true
        
        menuButton.menu = createMenu()
        menuButton.showsMenuAsPrimaryAction = true
        
        NSLayoutConstraint.activate([
            menuButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            menuButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            menuButton.heightAnchor.constraint(equalToConstant: 50),
            menuButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureProfileButton() {
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileButton)
        
        profileButton.setTitle("Show Profile", for: .normal)
        profileButton.setTitleColor(UIColor.systemGreen, for: .normal)
        profileButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        profileButton.addTarget(self, action: #selector(profileButtonTouch), for: UIControl.Event.touchUpInside)

        NSLayoutConstraint.activate([
            profileButton.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 10),
            profileButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            profileButton.heightAnchor.constraint(equalToConstant: 50),
            profileButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    @objc func profileButtonTouch()
        {
            let nextVC = ProfileView()
            
            let hostingController = UIHostingController(rootView: nextVC)
            
            navigationController?.pushViewController(hostingController, animated: true)
            
        }
    
    func createMenu() -> UIMenu {
        let actions = createActions()
        let menu = UIMenu(title: "Categories", children: actions)
        return menu
    }
    
    func createActions() -> [UIAction] {
        let restaurantFilterAction = UIAction(title: "Restaurant", handler: { _ in self.didTap("Restaurant") })
        let cafeFilterAction = UIAction(title: "Cafe", handler: { _ in self.didTap("Cafe") })
        let foodFilterAction = UIAction(title: "Food Market", handler: { _ in self.didTap("Food Market") })
        let pharmacyFilterAction = UIAction(title: "Pharmacy", handler: { _ in self.didTap("Pharmacy") })
        let wineryFilterAction = UIAction(title: "Winery", handler: { _ in self.didTap("Winery") })
        let bakeryFilterAction = UIAction(title: "Bakery", handler: { _ in self.didTap("Bakery") })
        let defaultFilterAction = UIAction(title: "Store (Default)", handler: { _ in self.didTap("Store") })
        
        let menuItems: [UIAction] = [restaurantFilterAction, cafeFilterAction, foodFilterAction, pharmacyFilterAction, wineryFilterAction, bakeryFilterAction, defaultFilterAction]
        
        return menuItems
    }
    
    @objc func didTap(_ categoryType: String) {
        performSearch(categoryType)
    }
    
    func configureCurrentCatLabel() {
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
    
    func configureTableView() {
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
    let mapButton = UIButton(type: .system)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureTextView()
        configureMapButton()
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
            textView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40) // Adjusted bottom anchor to avoid overlap
        ])
    }
    
    private func configureMapButton() {
        contentView.addSubview(mapButton)
        mapButton.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonColor = UIColor(red: 76/255.0, green: 163/255.0, blue: 75/255.0 , alpha: 1)

        mapButton.setTitle("View on Map", for: .normal)
        mapButton.setTitleColor(buttonColor, for: .normal)
        mapButton.addTarget(self, action: #selector(openInMaps), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            mapButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 5), // Adjusted top anchor
            mapButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            mapButton.heightAnchor.constraint(equalToConstant: 30),
            mapButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    @objc private func openInMaps() {
        guard let address = textView.text else { return }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                print("Geocode error: \(error.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?.first else {
                print("No location found for the address")
                return
            }
            
            let mapItem = MKMapItem(placemark: MKPlacemark(placemark: placemark))
            mapItem.name = self.textView.text
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
}

extension nearbyLandmarksVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return landmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //get the current day
        formatter.dateFormat = "YYYY-MM-dd"
        let res = formatter.string(from: currentDate)
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SelectableTextCell", for: indexPath) as? SelectableTextCell {
            let landmark = landmarks[indexPath.row]
            let discountInfo = landmarkDiscounts[landmark]
            let discount = discountInfo?.discount ?? "0"
            let couponCode = discountInfo?.couponCode ?? "CODE"
            let date3 = discountInfo?.date ?? "1/1/2024"
            //get ride of expired coupons
            if(date3 >= res){
                let attributedString = NSMutableAttributedString(string: "\(landmark.name)\n\(landmark.address)\nDiscount: \(discount)%\nCoupon Code: \(couponCode)\nUntil: \(date3)")
            
                let storeNameRange = (attributedString.string as NSString).range(of: landmark.name)
                let discountRange = (attributedString.string as NSString).range(of: "Discount: \(discount)%")
                let couponCodeRange = (attributedString.string as NSString).range(of: "Coupon Code: \(couponCode)")
                
                attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 18), range: storeNameRange)
                attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 16), range: discountRange)
                attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 16), range: couponCodeRange)
                
                if #available(iOS 13.0, *) {
                    let dynamicColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
                        return traitCollection.userInterfaceStyle == .dark ? .white : .black
                    }
                    attributedString.addAttribute(.foregroundColor, value: dynamicColor, range: NSRange(location: 0, length: attributedString.length))
                } else {
                    attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: attributedString.length))
                }
                let codeColor = UIColor(red: 112/255.0, green: 197/255.0, blue: 111/255.0 , alpha: 1)
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: codeColor, range: couponCodeRange)
                cell.textView.attributedText = attributedString
            }
            else{
                cell.isHidden = true
            }
            return cell
        } else {
            fatalError("Failed to dequeue SelectableTextCell")
        }
    }
    
}

extension nearbyLandmarksVC: CLLocationManagerDelegate {
    func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location
            locationManager.stopUpdatingLocation()
        }
    }
    
    func returnCat(_ selection: String) -> [MKPointOfInterestCategory] {
        var categories: [MKPointOfInterestCategory] = []
        
        switch selection {
        case "Bakery":
            categories.append(MKPointOfInterestCategory.bakery)
        case "Brewery":
            categories.append(MKPointOfInterestCategory.brewery)
        case "Cafe":
            categories.append(MKPointOfInterestCategory.cafe)
        case "Food Market":
            categories.append(MKPointOfInterestCategory.foodMarket)
        case "Pharmacy":
            categories.append(MKPointOfInterestCategory.pharmacy)
        case "Restaurant":
            categories.append(MKPointOfInterestCategory.restaurant)
        case "Store":
            categories.append(MKPointOfInterestCategory.store)
        case "Winery":
            categories.append(MKPointOfInterestCategory.winery)
        default:
            categories = [.bakery, .brewery, .cafe, .foodMarket, .pharmacy, .restaurant, .store, .winery]
        }
        
        return categories
    }
    
    func performSearch(_ query: String) {
        currentCatLabel.text = "\(query) Coupons"
        
        guard let location = currentLocation else {
            print("Current location is not available.")
            return
        }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        request.region = region
        
        let search = MKLocalSearch(request: request)
        
        search.start { [weak self] response, error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                print("Search error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response, !response.mapItems.isEmpty else {
                print("No results were found.")
                return
            }
            
            let categories = strongSelf.returnCat(query)
            
            let filteredItems = response.mapItems.filter { item in
                guard let category = item.pointOfInterestCategory else { return false }
                return categories.contains(category)
            }
            
            strongSelf.landmarks.removeAll()
            //put in task since retriving from database is async
            Task{
                for item in filteredItems {
                    if let postalAddress = item.placemark.postalAddress {
                        let formattedAddress = CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress)
                        let landmark = Landmark(name: item.name ?? "no name", address: formattedAddress)
                       
                        let randomNumber = arc4random_uniform(50)
                        let db = Firestore.firestore()
                        
                        var discount = "f"
                        var couponCode = "F"
                        var date = "f"
                        
                        
                        //get coupon code, description, and experation date from datebase
                        do{
                            let snapshot = try await db.collection("code").whereField("num", isEqualTo: randomNumber).getDocuments()
                            for documents in snapshot.documents{
                                //print("\(documents.data())")
                                couponCode = documents.get("code")! as! String
                                discount = documents.get("desc")! as! String
                                date = documents.get("date")! as! String
                            }
                        }
                        
                        
                        if let (_, _, _) = strongSelf.landmarkDiscounts[landmark] {
                            strongSelf.landmarks.append(landmark)
                        } else {
                            /*let discount = [5, 10, 15, 20].randomElement() ?? 0
                             let couponCode = UUID().uuidString.split(separator: "-").first ?? "CODE"*/
                            strongSelf.landmarkDiscounts[landmark] = (date,discount, String(couponCode))
                            strongSelf.landmarks.append(landmark)
                        }
                    }
                }
                
                
                strongSelf.table.reloadData()
            }
        }
    }
    }
    
    

