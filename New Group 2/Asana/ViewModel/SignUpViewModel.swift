//
//  SignUpViewModel.swift
//  Asana
//
//  Created by Kiran T C on 09/09/25.
//

import Foundation

class SignUpViewModel: ObservableObject {
    @Published var fullName = ""
    @Published var age = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""

    @Published var goToHome = false
    @Published var isSigningUp = false
    @Published var signUpError: String?

    // MARK: - Business Logic
    func handleSignUp() {
        signUpError = nil

        guard !fullName.trimmingCharacters(in: .whitespaces).isEmpty else {
            signUpError = "Please enter your full name."
            return
        }
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            signUpError = "Please enter your email address."
            return
        }
        guard password == confirmPassword else {
            signUpError = "Passwords do not match."
            return
        }
        guard password.count >= 8 else {
            signUpError = "Password must be at least 8 characters."
            return
        }

        isSigningUp = true

        AuthService.shared.signUp(email: email, password: password) { result in
            DispatchQueue.main.async {
                self.isSigningUp = false
                switch result {
                case .success(_):
                    self.signUpError = nil
                    self.goToHome = true
                case .failure(let err):
                    self.signUpError = err.localizedDescription
                }
            }
        }
    }
}
