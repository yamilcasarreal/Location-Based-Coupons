//
//  SignInButton.swift
//  Location-Based-Coupons
//
//  Created by Yamil Casarreal on 2/27/24.
//

import SwiftUI

struct SignInButton: View {
    let title: String
    let action: String
    var body: some View {
        VStack {
            Button {
                print(title)
            } label: {
                HStack {
                    Text(action)
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(Color(.systemGreen))
            .cornerRadius(30)
            .padding(.top, 24)
        }
    }
}

#Preview {
    SignInButton(title: "Log User in...", action: "SIGN IN")
}
