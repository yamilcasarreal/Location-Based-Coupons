//
//  EditProfileView.swift
//  Location-Based-Coupons
//
//  Created by Yamil Casarreal on 4/19/24.
//

import SwiftUI

struct EditProfileView: View {
    @State private var fullname = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        ZStack {
            VStack{
                //image
                Image("coupON2")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 200)
                    .padding(.vertical, 32)
                
                
                //forms
                VStack (spacing: 24) {
                    
                    InputView(text: $fullname,
                              title: "Edit Full Name",
                              placeholder: "Enter First and Last Name")
                    
                    
                    
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                //Sign Up Button
                Button {
                    Task {
                        try await viewModel.editUser(fullName: fullname)
                        
                        dismiss()
                        
                    }
                } label: {
                    HStack {
                        Text("Make changes")
                            .fontWeight(.semibold)
                        //Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemGreen))
                .cornerRadius(30)
                .padding(.top, 24)
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 3){
                        Text("Don't want to make any changes?")
                        Text("Go Back")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    .font(.system(size: 15))
                    .foregroundColor(.green)
                }
            }
            if viewModel.isLoading {
                CustomProgressView()
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"),
                  message: Text(viewModel.authError?.description ?? ""))
        }
    }
}

extension EditProfileView: AuthenticationFormProtocol{
    var formIsValid: Bool {
        return !fullname.isEmpty
        
    }
}
