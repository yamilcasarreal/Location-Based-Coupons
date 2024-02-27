//
//  LoginView.swift
//  Location-Based-Coupons
//
//  Created by Yamil Casarreal on 2/27/24.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        NavigationStack {
            VStack {
                //image
                Image("coupON2")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 200)
                    .padding(.vertical, 32)
                //form fields
                
                //sign in button
                Spacer()
                
                //sign up button
            }
        }
    }
}

#Preview {
    LoginView()
}
