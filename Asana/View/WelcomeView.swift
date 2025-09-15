//
//  WelcomeView.swift
//  Asana
//
//  Created by Kiran T C on 03/09/25.
//

import SwiftUI

struct WelcomeView: View {
    
    @State private var isHovering = false
    @State private var goToLogin = false   // 👈 Track navigation
    
    var body: some View {
        if goToLogin {
            // 👈 Once this is true, Welcome disappears & LoginView takes over
            LoginView()
        } else {
                VStack(spacing: 28) {
                    Spacer(minLength: 24)

                    // Title
                    VStack(spacing: 8) {
                        Text("Welcome To")
                            .font(.system(.title2, design: .serif))
                            .fontWeight(.semibold)
                            .foregroundStyle(.black.opacity(0.8))

                        Text("Āsana.")
                            .font(.system(size: 44, weight: .bold, design: .serif))
                            .foregroundStyle(Color(hex: "#EB784E")!)
                    }

                    // Subtitle
                    Text("Transform your body and mind with\nour comprehensive yoga app.")
                        .multilineTextAlignment(.center)
                        .font(.system(.title3, design: .serif))
                        .foregroundStyle(.black.opacity(0.8))
                        .padding(.horizontal, 24)

                    // CTA → Replaces Welcome with LoginView
                    Button {
                        goToLogin = true   // 👈 Navigate to Login
                    } label: {
                        Text("Start Journey")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 40)
                            .background(
                                (isHovering ? Color(hex: "#EB784E")!.opacity(0.7) : Color(hex: "#EB784E"))
                                    .animation(.easeInOut(duration: 0.2), value: isHovering)
                            )
                            .cornerRadius(30)
                            .shadow(color: .gray.opacity(0.4), radius: 4, x: 0, y: 3)
                    }
                    .padding(.horizontal, 50)
                    .onHover { hovering in
                        isHovering = hovering
                    }

                    // Illustration
                    Image("welcomeView")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 520, maxHeight: 360)
                        .padding(.top, 8)

                    Spacer(minLength: 32)
                }
                .frame(maxWidth: 640, maxHeight: .infinity, alignment: .center)
                .padding(.horizontal, 16)
                .multilineTextAlignment(.center)
                .background(Color("BackgroundColor").ignoresSafeArea())
        }
    }
}

#Preview {
    Group {
        WelcomeView()                    // iPhone
        WelcomeView()                    // iPad
        WelcomeView()                    // macOS
            .frame(width: 900, height: 700)
    }
}
