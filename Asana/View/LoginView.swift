//
//  LoginView.swift
//  Asana
//
//  Created by Kiran T C on 03/09/25.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @ObservedObject private var authService = AuthService.shared
    @State private var navigateToHome = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                // Logo / App Name
                Text("Āsana.")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#EB784E"))
                    .padding(.top, 40)
                
                Spacer().frame(height: 20)
                
                // Email
                VStack(alignment: .leading, spacing: 8) {
                    Text("Come On In.")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.top, 10)
                    
                    Spacer().frame(height: 20)
                    
                    TextField("Email address", text: $viewModel.email)
                        #if os(iOS)
                        .textInputAutocapitalization(.none)
                        .keyboardType(.emailAddress)
                        #endif
                        .padding(.vertical, 10)
                        .textFieldStyle(PlainTextFieldStyle())
                    Divider()
                }
                .padding(.horizontal, 30)
                
                // Password
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        if viewModel.isPasswordVisible {
                            TextField("Password (8 characters min)", text: $viewModel.password)
                        } else {
                            SecureField("Password (8 characters min)", text: $viewModel.password)
                        }
                        Button {
                            viewModel.isPasswordVisible.toggle()
                        } label: {
                            Image(systemName: viewModel.isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 10)
                    Divider()
                }
                .padding(.horizontal, 30)
                
                // Forgot Password
                HStack {
                    Spacer()
                    Button("Forgot Password?") {
                        // TODO
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                }
                .padding(.horizontal, 30)
                .padding(.top, 4)
                
                // Login Button
                Button {
                    viewModel.loginWithEmail()
                } label: {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "#EB784E"))
                        .cornerRadius(10)
                        .shadow(color: .gray.opacity(0.4), radius: 3, x: 0, y: 3)
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
                
                // Error Message
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .padding(.horizontal, 30)
                }
                
                // OR Divider
                Text("or")
                    .foregroundColor(.gray)
                    .padding(.vertical, 8)
                
                // Google Button
                Button {
                    viewModel.loginWithGoogle()
                } label: {
                    HStack {
                        Image(systemName: "globe")
                            .foregroundColor(.red)
                        Text("Sign In with Google")
                            .foregroundColor(.black)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .gray.opacity(0.3), radius: 2, x: 0, y: 2)
                }
                .padding(.horizontal, 30)
                
                // Apple Button
                Button {
                    // TODO
                } label: {
                    HStack {
                        Image(systemName: "applelogo")
                            .foregroundColor(.black)
                        Text("Sign In with Apple")
                            .foregroundColor(.black)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .gray.opacity(0.3), radius: 2, x: 0, y: 2)
                }
                .padding(.horizontal, 30)
                
                // Create Account
                NavigationLink(destination: SignUpView()) {
                    Text("Create an account >")
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .padding(.top, 30)
            .background(
                Group {
                    #if os(iOS)
                    Color(UIColor.systemGray6)
                    #elseif os(macOS)
                    Color(NSColor.windowBackgroundColor)
                    #endif
                }
                .ignoresSafeArea()
            )
            // 👇 Listen to AuthService instead of isLoggedIn
            .onChange(of: authService.user, initial: false) { oldUser, newUser in
                navigateToHome = (newUser != nil)
            }
            .navigationDestination(isPresented: $navigateToHome) {
                HomeView()
            }
        }
    }
}

#Preview {
    LoginView()
}

