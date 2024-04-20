//
//  ResetPasswordView.swift
//  Location-Based-Coupons
//
//  Created by Yamil Casarreal on 4/3/24.
//

import SwiftUI

struct ResetPasswordView: View {
    @State private var email = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Image("coupON2")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 140)
                .padding(.vertical, 32)
            
            
            InputView(text: $email,
                      title: "Email Address",
                      placeholder: "Enter the email associated with your account")
            .padding()
            .autocapitalization(.none)

            
            Button {
                viewModel.sendResetPasswordLink(toEmail: email)
                dismiss()
            } label: {
                HStack {
                    Text("SEND RESET LINK")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 50)
            }
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.5)
            .background(Color(.systemGreen))
            .cornerRadius(10)
            .padding()
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                HStack {
                    Image(systemName: "arrow.left")
                    .foregroundColor(.green)

                    
                    Text("Back to Login")
                        .fontWeight(.semibold)
                        .foregroundColor(.green)

                }
            }
        }
    }
}
extension ResetPasswordView: AuthenticationFormProtocol{
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
    }
}
#Preview {
    ResetPasswordView()
}
