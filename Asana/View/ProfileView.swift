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
    @State private var showStreaks = false
    @State private var showReminder: Bool = false
    @State private var showFaq: Bool = false
    @State private var showAccount: Bool = false

    var body: some View {
        VStack(spacing: 24) {
            // User Info Card
            Spacer()
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

            ScrollView{
                SectionView(title: "SETTINGS", items: [
                    "Manage Account", "Current Streak", "Reminders"
                ]){ tapped in
                    if tapped == "Current Streak" {
                        showStreaks = true
                    } else if tapped == "Reminders"{
                        showReminder = true
                    } else if tapped == "Manage Account"{
                        showAccount = true
                    }
                }
                
                
                SectionView(title: "SUPPORT", items: [
                    "Frequently Asked Questions", "Contact Support", "Privacy Policy"
                ]){ tapped in
                    if tapped == "Frequently Asked Questions" {
                        showFaq = true
                    } else if tapped == "Privacy Policy"{
                        openURL("https://www.vanasol.com/asana-privacy-policy/")
                    }
                }
            }
            Spacer()

            
            Button(action: { vm.signOut() }) {
                Text("Sign Out")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.red)
            }
            .padding(.bottom, 20)

        }
        .background(Color(hex: "#EAF2F2").ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          
    
            ToolbarItem(placement: .principal) {
                Text("Profile")
                    .font(.system(size: 29, weight: .bold, design: .serif))
                    .foregroundColor(Color(hex: "#EB784E"))
            }
        }
        
        .sheet(isPresented: $showStreaks) {
                    AllStreaksCalendarView()   
                }
        .sheet(isPresented: $showReminder){
             ReminderView()
        }
        .sheet(isPresented: $showFaq){
             FAQView()
        }
        .sheet(isPresented: $showAccount) {
            ManageAccountView()
        }
        
    }
    
    private func openURL(_ urlString: String) {
        
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
        
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
                        .font(.system(size: 16, weight: .bold, design: .serif))
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
