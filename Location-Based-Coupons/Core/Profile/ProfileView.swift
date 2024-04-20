import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var isDarkMode = false
    @State private var showAlert = false
    

    
    var body: some View {
        NavigationStack{
            ZStack {
                VStack{
//                    Button {
//                        viewModel.signout()
//                    } label: {
//                        SettingsRowView(imageName: "circle.fill",
//                                        title: "Reset Password",
//                                        tintColor: Color(.systemGreen),
//                                        titleColor: colorScheme == .dark ? .white : .black)
//                    }
                    if let user = viewModel.currentUser {
                        
                        
                        List {
                            Section {
                                HStack{
                                    Text(user.initials)
                                        .font(.title)
                                        .fontWeight(.semibold)
                                        .foregroundColor(colorScheme == .dark ? .white : .black) // Set text color based on theme
                                        .frame(width: 72, height: 72)
                                        .background(Color(.systemGreen))
                                        .clipShape(Circle())
                                    
                                    VStack (alignment: .leading, spacing: 4) {
                                        Text(user.fullName)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .padding(.top, 4)
                                            .foregroundColor(colorScheme == .dark ? .white : .black) // Set text color based on theme
                                        
                                        Text(user.email)
                                            .font(.footnote)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            
                            Section(header: Text("General").foregroundColor(colorScheme == .dark ? .white : .black)) { // Set section header text color based on theme
                                HStack {
                                    SettingsRowView(imageName: "gear",
                                                    title: "Version",
                                                    tintColor: Color(.systemGray),
                                                    titleColor: colorScheme == .dark ? .white : .black)
                                    
                                    Spacer()
                                    
                                    Text("1.0.0")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                }
                            }
                            
                            Section(header: Text("Account").foregroundColor(colorScheme == .dark ? .white : .black)) { // Set section header text color based on theme
                                
                                //Edit Profile 
                                NavigationStack {
                                    NavigationLink{
                                        EditProfileView()
                                        .navigationBarBackButtonHidden(true)
                                    } label: {
                                        SettingsRowView(imageName: "circle.fill",
                                                        title: "Edit Profile",
                                                        tintColor: Color(.systemGreen),
                                                        titleColor: colorScheme == .dark ? .white : .black)
                                    }
                                }
                                
                                Button {
                                    viewModel.sendResetPasswordLink(toEmail: user.email)
                                    showAlert = true
                                    //viewModel.signout()
                                } label: {
                                    SettingsRowView(imageName: "circle.fill",
                                                    title: "Reset Password",
                                                    tintColor: Color(.systemGreen),
                                                    titleColor: colorScheme == .dark ? .white : .black)
                                }
                                Button{
                                    viewModel.signout()
                                } label: {
                                    SettingsRowView(imageName: "arrow.left.circle.fill",
                                                    title: "Sign Out",
                                                    tintColor: .red,
                                                    titleColor: colorScheme == .dark ? .white : .black)
                                }
                               
                                Button {
                                    Task {
                                        try await viewModel.deleteAccount()
                                    }
                                } label: {
                                    SettingsRowView(imageName: "xmark.circle.fill",
                                                    title: "Delete Account",
                                                    tintColor: Color(.systemRed),
                                                    titleColor: colorScheme == .dark ? .white : .black)
                                }
                                Button(action: {
                                    self.isDarkMode.toggle()
                                    UserDefaults.standard.set(self.isDarkMode, forKey: "isDarkMode")
                                    if #available(iOS 13.0, *) {
                                        UIApplication.shared.windows.forEach { window in
                                            if let scene = window.windowScene {
                                                scene.windows.forEach { window in
                                                    window.overrideUserInterfaceStyle = self.isDarkMode ? .dark : .light
                                                }
                                            }
                                        }
                                    }
                                }) {
                                    SettingsRowView(imageName: isDarkMode ? "sun.max.fill" : "moon.fill",
                                                    title: isDarkMode ? "Switch to Light Theme" : "Switch to Dark Theme",
                                                    tintColor: isDarkMode ? .yellow : .blue,
                                                    titleColor: colorScheme == .dark ? .white : .black)
                                }
                            }
                            
                        }
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(""), message: Text("A reset password link has been sent to your email, you will now be signed out"), dismissButton: .default(Text("Ok"), action: {
                        viewModel.signout()
                    }))
                }
                if viewModel.isLoading {
                    CustomProgressView()
                }
            }
            .onAppear {
                if let isDarkMode = UserDefaults.standard.object(forKey: "isDarkMode") as? Bool {
                    self.isDarkMode = isDarkMode
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

