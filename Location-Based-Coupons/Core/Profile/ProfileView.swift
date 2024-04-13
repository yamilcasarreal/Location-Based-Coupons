//
//  ProfileView.swift
//  Location-Based-Coupons
//
//  Created by Yamil Casarreal on 2/28/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        ZStack {
            VStack{
                if let user = viewModel.currentUser {
                    List {
                        Section {
                            HStack{
                                Text(user.initials)
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(width: 72, height: 72)
                                    .background(Color(.systemGreen))
                                    .clipShape(Circle())
                                
                                VStack (alignment: .leading, spacing: 4) {
                                    Text(user.fullName)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .padding(.top, 4)
                                    
                                    Text(user.email)
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        
                        Section ("General") {
                            HStack {
                                SettingsRowView(imageName: "gear",
                                                title: "Version",
                                                tintColor: Color(.systemGray))
                                Spacer()
                                
                                Text("1.0.0")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Section ("Account"){
                            Button{
                                viewModel.signout()
                            } label: {
                                SettingsRowView(imageName: "arrow.left.circle.fill",
                                                title: "Sign Out",
                                                tintColor: .red)
                            }
                            Button {
                                Task {
                                    try await viewModel.deleteAccount()
                                }
                            } label: {
                                SettingsRowView(imageName: "xmark.circle.fill",
                                                title: "Delete Account",
                                                tintColor: Color(.systemRed))
                            }
                        }
                        
                    }
                }
            }
            if viewModel.isLoading {
                CustomProgressView()
            }
        }
    }
        
}

#Preview {
    ProfileView()
}
