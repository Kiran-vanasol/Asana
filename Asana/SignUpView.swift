//
//  SignUpView.swift
//  Asana
//
//  Created by Kiran T C on 04/09/25.
//

import SwiftUI

struct SignUpView: View {
    #if os(iOS)
    @Environment(\.dismiss) private var dismiss
    #else
    @Environment(\.presentationMode) private var presentationMode
    #endif

    @State private var fullName = ""
    @State private var age = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false

    @State private var goToHome = false
    @State private var isSigningUp = false
    @State private var signUpError: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {

                // Header
                HStack {
                    Button(action: {
                        #if os(iOS)
                        dismiss()
                        #else
                        presentationMode.wrappedValue.dismiss()
                        #endif
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    #if os(macOS)
                    .buttonStyle(.plain)
                    #endif

                    Spacer()

                    Text("Āsana.")
                        .font(.system(size: 28, weight: .bold, design: .serif))
                        .foregroundColor(.orange)

                    Spacer()
                        .frame(width: 44)
                }
                .padding(.horizontal)
                .padding(.top, 16)

                // Title
                Text("We’re So Pleased To Meet You.")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal)

                // Input Fields
                Group {
                    CustomTextField(placeholder: "Full name", text: $fullName, isSecure: false)

                    CustomTextField(placeholder: "Age", text: $age, isSecure: false)
                        #if os(iOS)
                        .keyboardType(.numberPad)
                        #endif

                    CustomTextField(placeholder: "Email address", text: $email, isSecure: false)
                        #if os(iOS)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        #endif

                    CustomTextField(
                        placeholder: "Password (8 characters min)",
                        text: $password,
                        isSecure: !showPassword,
                        showToggle: true,
                        isVisible: $showPassword
                    )

                    CustomTextField(
                        placeholder: "Confirm Password",
                        text: $confirmPassword,
                        isSecure: !showConfirmPassword,
                        showToggle: true,
                        isVisible: $showConfirmPassword
                    )
                }
                .padding(.horizontal)

                // Error message
                if let e = signUpError {
                    Text(e)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.horizontal)
                        .padding(.top, 6)
                }

                // Sign Up Button
                Button(action: handleSignUp) {
                    HStack {
                        Spacer()
                        Text(isSigningUp ? "Signing up..." : "Sign Up")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(30)
                    .shadow(radius: 3)
                }
                .disabled(isSigningUp)
                .padding(.horizontal)
                .padding(.top, 8)

                // Or / Already have an account
                Text("or")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 12)

                Button(action: {
                    #if os(iOS)
                    dismiss()
                    #else
                    presentationMode.wrappedValue.dismiss()
                    #endif
                }) {
                    Text("Already have an account?")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.black)
                }
                #if os(macOS)
                .buttonStyle(.plain)
                #endif
                .padding(.top, 4)

                Spacer(minLength: 12)

                // Terms
                Text("By signing into Āsana, you understand and agree to Āsana Terms & Conditions & Privacy Policy")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom, 30)
            }
            .padding(.top, 4)
        }
        .background(Color("BackgroundColor").ignoresSafeArea())
        .navigationDestination(isPresented: $goToHome) {
            HomeView()
        }
    }

    // MARK: - Sign Up Logic
    private func handleSignUp() {
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
                isSigningUp = false
                switch result {
                case .success(_):
                    signUpError = nil
                    goToHome = true
                case .failure(let err):
                    signUpError = err.localizedDescription
                }
            }
        }
    }
}

// MARK: - Custom TextField
struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool
    var showToggle: Bool = false
    @Binding var isVisible: Bool

    init(placeholder: String,
         text: Binding<String>,
         isSecure: Bool,
         showToggle: Bool = false,
         isVisible: Binding<Bool> = .constant(false)) {
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
        self.showToggle = showToggle
        self._isVisible = isVisible
    }

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }

                if showToggle {
                    Button(action: { isVisible.toggle() }) {
                        Image(systemName: isVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                    #if os(macOS)
                    .buttonStyle(.plain)
                    #endif
                }
            }
            .padding(.vertical, 12)

            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray.opacity(0.6))
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        SignUpView()
    }
}
