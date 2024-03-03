//
//  Location_Based_CouponsApp.swift
//  Location-Based-Coupons
//
//  Created by Yamil Casarreal on 2/26/24.
//

import SwiftUI
import Firebase
@main
struct Location_Based_CouponsApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    
    init(){
        FirebaseApp.configure()
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
