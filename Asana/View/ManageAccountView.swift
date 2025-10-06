//
//  ManageAccountView.swift
//  Asana
//
//  Created by Kiran T C on 06/10/25.
//

import SwiftUI

struct ManageAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = ManageAccountViewModel()
    
    @State private var name: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .font(.title2)
                }
                Spacer()
                Text("Manage Account")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color(hex: "#EB784E"))
                Spacer()
            }
            .padding()
            ScrollView{
                
                // Profile Info
                VStack(alignment: .leading, spacing: 12) {
                    Text("Profile Info").font(.caption).foregroundColor(.gray)
                    
                    TextField("Name", text: $name)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    Text(vm.userEmail)
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
                .padding(.horizontal)
                
                // Change Password
                VStack(alignment: .leading, spacing: 12) {
                    Text("Change Password").font(.caption).foregroundColor(.gray)
                    SecureField("New Password", text: $vm.newPassword)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    SecureField("Confirm Password", text: $vm.confirmPassword)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    Button(action: { vm.updatePassword { success, msg in
                        alertMessage = msg
                        showAlert = true
                    }}) {
                        Text("Update Password")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "#F17228"))
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
            }
            Spacer()
            
            // Delete Account
            Button(action: { vm.deleteAccount { success, msg in
                alertMessage = msg
                showAlert = true
                if success { dismiss() }
            }}) {
                Text("Delete Account")
                    .foregroundColor(.red)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            
        }
        .background(Color(hex: "#EAF2F2").ignoresSafeArea())
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Info"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            self.name = vm.userName
        }
    }
}

