//
//  ProfileViewModel.swift
//  Asana
//
//  Created by Kiran T C on 11/09/25.
//

// ViewModel/ProfileViewModel.swift
import Foundation
import FirebaseAuth

class ProfileViewModel: ObservableObject {
    @Published var profile: Profile?

    init() {
        loadProfile()
    }

    func loadProfile() {
        guard let user = AuthService.shared.currentUser else { return }
        profile = Profile(
            name: user.displayName ?? "User",
            email: user.email ?? "",
            photoURL: user.photoURL
        )
    }

    func signOut() {
        AuthService.shared.signOut()
        profile = nil
    }
}

