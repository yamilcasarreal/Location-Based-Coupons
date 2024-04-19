//
//  ContentView.swift
//  Location-Based-Coupons
//
//  Created by Yamil Casarreal on 2/26/24.
//

import UIKit
import CoreLocation
import MapKit
import Contacts

struct NearbyLandmarksVCRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> nearbyLandmarksVC {
        // Instantiate the nearbyLandmarksVC here
        return nearbyLandmarksVC()
    }
    
    func updateUIViewController(_ uiViewController: nearbyLandmarksVC, context: Context) {
        // Update the view controller if needed
    }
}



import SwiftUI

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
