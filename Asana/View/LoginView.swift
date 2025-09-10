//
//  LoginView.swift
//  Asana
//
//  Created by Kiran T C on 03/09/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                // Logo / App Name
                Text("Āsana.")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                    .padding(.top, 40)
                
                // Subtitle
                Text("Come On In.")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top, 10)
                
                Spacer().frame(height: 20)
                
                // Email
                VStack(alignment: .leading, spacing: 8) {
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
                        Button(action: {
                            viewModel.isPasswordVisible.toggle()
                        }) {
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
                    Button(action: {
                        // TODO: implement Forgot Password
                    }) {
                        Text("Forgot Password?")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 4)
                
                // Login Button
                Button(action: {
                    viewModel.loginWithEmail()
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
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
                Button(action: {
                    viewModel.loginWithGoogle()
                }) {
                    HStack {
                        Image(systemName: "globe") // Replace with real Google logo
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
                Button(action: {
                    // TODO: implement Apple sign in
                }) {
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
                
                // Navigate to HomeView when login succeeds
                .navigationDestination(isPresented: $viewModel.isLoggedIn) { HomeView() }
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
        }
    }
}

#Preview {
    LoginView()
}
