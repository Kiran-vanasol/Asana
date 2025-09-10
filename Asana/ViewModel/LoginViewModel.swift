//
//  LoginViewModel.swift
//  Asana
//
//  Created by Kiran T C on 09/09/25.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false
    @Published var errorMessage: String?
    @Published var isLoggedIn: Bool = false

    // MARK: - Firebase Email/Password Login
    func loginWithEmail() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                } else {
                    print("Logged in as \(result?.user.email ?? "unknown")")
                    self.errorMessage = nil
                    self.isLoggedIn = true
                }
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
            self.handleGoogleResult(signInResult, error: error)
        }
        
        #elseif os(macOS)
        // --- macOS flow ---
        if let window = NSApplication.shared.windows.first {
            GIDSignIn.sharedInstance.signIn(withPresenting: window) { signInResult, error in
                self.handleGoogleResult(signInResult, error: error)
            }
        }
        #endif
    }
    
    // MARK: - Common handler
    private func handleGoogleResult(_ signInResult: GIDSignInResult?, error: Error?) {
        if let error = error {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
            return
        }
        
        guard let result = signInResult,
              let idToken = result.user.idToken else {
            DispatchQueue.main.async {
                self.errorMessage = "Google Sign-In failed."
            }
            return
        }
        
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken.tokenString,
            accessToken: result.user.accessToken.tokenString
        )
        
        Auth.auth().signIn(with: credential) { authResult, error in
            DispatchQueue.main.async {
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
}
