//
//  LoginView.swift
//  Location-Based-Coupons
//
//  Created by Yamil Casarreal on 2/27/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
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
                VStack (spacing: 24) {
                    InputView(text: $email, 
                              title: "Email Address",
                              placeholder: "name@email.com")
                    .autocapitalization(.none)
                    
                    InputView(text: $password, 
                              title: "Password", placeholder: "Enter your password",
                              isSecureField: true)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                //sign in button
                SignInButton(title: "Sign User in...", action: "SIGN IN")
                Spacer()
                
                //sign up button
                NavigationLink{
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3){
                        Text("Don't have an account?")
                        Text("Sign Up")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    .font(.system(size: 15))
                    .foregroundColor(.green)
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
