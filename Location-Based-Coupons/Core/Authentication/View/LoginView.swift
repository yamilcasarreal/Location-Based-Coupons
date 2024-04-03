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
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
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
                        .autocapitalization(.none)
                        
                        NavigationLink {
                            ResetPasswordView()
                                .navigationBarHidden(true)
                        } label: {
                            Text("Forgot Password?")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.green)
                            
                        }
                        .padding(.bottom)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        
                    }
                    
                    .padding(.horizontal)
                    .padding(.top, 12)
                    
                    //sign in button
                    Button {
                        Task {
                            try await viewModel.signIn(withEmail: email, password: password)
                        }
                    } label: {
                        HStack {
                            Text("SIGN IN")
                                .fontWeight(.semibold)
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    }
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5)
                    .background(Color(.systemGreen))
                    .cornerRadius(30)
                    .padding(.top, 24)
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
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Error"),
                          message: Text(viewModel.authError?.description ?? ""))
                }
                
                if viewModel.isLoading {
                    CustomProgressView()
                }
            }
        }
    }
}

//checks to see if the email/password format is valid
extension LoginView: AuthenticationFormProtocol{
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}
#Preview {
    LoginView()
}
