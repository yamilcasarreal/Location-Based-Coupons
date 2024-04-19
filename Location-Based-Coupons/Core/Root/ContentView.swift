//
//  ContentView.swift
//  Location-Based-Coupons
//
//  Created by Yamil Casarreal on 2/26/24.
//

import SwiftUI
import UIKit
import CoreLocation
import MapKit
import Contacts

// Wrapper that lets us use a UIKit VC in SwiftUI; in this case we return a nav controller instead of a VC to push a View into the nav stack

struct NearbyLandmarksVCRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UINavigationController {
        
        let nearbyLandVC = nearbyLandmarksVC()
        let navigationController = UINavigationController(rootViewController: nearbyLandVC)
        return navigationController

    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // Update the view controller if needed
    }
}

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group{
            if viewModel.userSession != nil {
                NearbyLandmarksVCRepresentable()
            }
            else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
