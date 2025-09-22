//
//  ProfileView.swift
//  Asana
//
//  Created by Kiran T C on 11/09/25.
//
// View/ProfileView.swift
import SwiftUI

struct ProfileView: View {
    @StateObject private var vm = ProfileViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showStreaks = false ///   to show streaksss

    var body: some View {
        VStack(spacing: 24) {
            
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                Spacer()
                Text("Profile")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.black)
                Spacer()
                // Keep space for symmetry
                Color.clear.frame(width: 24, height: 24)
            }
            .padding(.horizontal)
            .padding(.top, 12)

            // User Info Card
            if let profile = vm.profile {
                HStack(spacing: 12) {
                    if let url = profile.photoURL {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let img):
                                img.resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            default:
                                Circle().fill(Color.gray).frame(width: 50, height: 50)
                            }
                        }
                    } else {
                        Circle().fill(Color.gray).frame(width: 50, height: 50)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(profile.name)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        Text(profile.email)
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.9))
                    }

                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(hex: "#F17228"))
                .cornerRadius(12)
                .padding(.horizontal)
            }

        
            SectionView(title: "SETTINGS", items: [
                "Manage Account", "Current Streak", "Reminders"
            ]){ tapped in
                if tapped == "Current Streak" {
                    showStreaks = true
                }
            }

            
            SectionView(title: "SUPPORT", items: [
                "Frequently Asked Questions", "Contact Support", "Privacy Policy"
            ])

            Spacer()

            
            Button(action: { vm.signOut() }) {
                Text("Sign Out")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.red)
            }
            .padding(.bottom, 20)

        }
        .navigationBarHidden(true)
        .background(Color(hex: "#F8F8F8").ignoresSafeArea())
        
        .sheet(isPresented: $showStreaks) {
                    AllStreaksCalendarView()   
                }
    }
}

// Reusable Section
struct SectionView: View {
    var title: String
    var items: [String]
    var onItemTap: ((String) -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .padding(.horizontal)

            ForEach(items, id: \.self) { item in
                Button(action: { onItemTap?(item) }) {
                    Text(item)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
        }
        .padding(.top, 8)
    }
}
