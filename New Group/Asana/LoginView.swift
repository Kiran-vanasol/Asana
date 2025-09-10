//
//  LoginView.swift
//  Asana
//
//  Created by Kiran T C on 03/09/25.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var errorMessage: String?
    @State private var isLoggedIn: Bool = false   // track login success

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
                    TextField("Email address", text: $email)
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
                        if isPasswordVisible {
                            TextField("Password (8 characters min)", text: $password)
                        } else {
                            SecureField("Password (8 characters min)", text: $password)
                        }
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
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
                        // forgot password action
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
                    loginWithEmail()
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
                if let errorMessage = errorMessage {
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
                    loginWithGoogle()
                }) {
                    HStack {
                        Image(systemName: "globe") // Replace with real Google logo asset if available
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
                
                // Apple Button (not yet wired)
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
                
                // Create Account → Navigate to SignUpView
                NavigationLink(destination: SignUpView()) {
                    Text("Create an account >")
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }
                .padding(.top, 10)
                
                Spacer()
                
                // Navigate to HomeView when login succeeds
            .navigationDestination(isPresented: $isLoggedIn) { HomeView() }
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
    
    // MARK: - Firebase Email/Password Login
    func loginWithEmail() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                print("Logged in as \(result?.user.email ?? "unknown")")
                self.errorMessage = nil
                self.isLoggedIn = true  // trigger navigation
            }
        }
    }
    
    // MARK: - Google Sign-In
    func loginWithGoogle() {
        guard (FirebaseApp.app()?.options.clientID) != nil else { return }

        #if os(iOS)
        // --- iOS flow ---
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
            handleGoogleResult(signInResult, error: error)
        }
        
        #elseif os(macOS)
        // --- macOS flow ---
        if let window = NSApplication.shared.windows.first {
            GIDSignIn.sharedInstance.signIn(withPresenting: window) { signInResult, error in
                handleGoogleResult(signInResult, error: error)
            }
        }
        #endif
    }
    
    // MARK: - Common handler
    private func handleGoogleResult(_ signInResult: GIDSignInResult?, error: Error?) {
        if let error = error {
            self.errorMessage = error.localizedDescription
            return
        }
        
        guard let result = signInResult,
              let idToken = result.user.idToken else {
            self.errorMessage = "Google Sign-In failed."
            return
        }
        
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken.tokenString,
            accessToken: result.user.accessToken.tokenString
        )
        
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                print("Google login success: \(authResult?.user.email ?? "unknown")")
                self.errorMessage = nil
                self.isLoggedIn = true
            }
        }
    }
}

#Preview {
    LoginView()
}
