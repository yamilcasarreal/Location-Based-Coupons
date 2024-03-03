//
//  ContentView.swift
//  Location-Based-Coupons
//
//  Created by Yamil Casarreal on 2/26/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group{
            if viewModel.userSession != nil {
                ProfileView()
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
