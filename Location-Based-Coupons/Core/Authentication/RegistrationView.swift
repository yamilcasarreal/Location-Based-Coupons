//
//  RegistrationView.swift
//  Location-Based-Coupons
//
//  Created by Yamil Casarreal on 2/27/24.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmpassword = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack{
            //image
            Image("coupON2")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 200)
                .padding(.vertical, 32)
            
            
            //forms
            VStack (spacing: 24) {
                InputView(text: $email,
                          title: "Email Address",
                          placeholder: "name@email.com")
                .autocapitalization(.none)
                
                InputView(text: $fullname,
                          title: "Full Name",
                          placeholder: "Enter First and Last Name")
                
                InputView(text: $password,
                          title: "Password", placeholder: "Enter your password",
                          isSecureField: true)
                
                InputView(text: $confirmpassword,
                          title: "Confirm Password", placeholder: "Confirm Your Password",
                          isSecureField: true)
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            //Sign Up Button
            SignInButton(title: "Sign Up...", action: "SIGN UP")
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3){
                    Text("Already have an account?")
                    Text("Sign In")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
                .font(.system(size: 15))
                .foregroundColor(.green)
            }
        }
        
    }
}

#Preview {
    RegistrationView()
}
