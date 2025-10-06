//
//  ManageAccountViewModel.swift
//  Asana
//
//  Created by Kiran T C on 06/10/25.
//

import FirebaseAuth
import SwiftUI

@MainActor
class ManageAccountViewModel: ObservableObject {
    @Published var userName: String = ""
    @Published var userEmail: String = ""
    @Published var newPassword: String = ""
    @Published var confirmPassword: String = ""
    
    init() {
        if let user = Auth.auth().currentUser {
            self.userName = user.displayName ?? ""
            self.userEmail = user.email ?? ""
        }
    }
    
    func updateName(newName: String, completion: @escaping (Bool, String) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = newName
        changeRequest.commitChanges { error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                self.userName = newName
                completion(true, "Name updated successfully")
            }
        }
    }
    
    func updatePassword(completion: @escaping (Bool, String) -> Void) {
        guard newPassword == confirmPassword else {
            completion(false, "Passwords do not match")
            return
        }
        guard let user = Auth.auth().currentUser else { return }
        user.updatePassword(to: newPassword) { error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                self.newPassword = ""
                self.confirmPassword = ""
                completion(true, "Password updated successfully")
            }
        }
    }
    
    func deleteAccount(completion: @escaping (Bool, String) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        user.delete { error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, "Account deleted successfully")
            }
        }
    }
}
