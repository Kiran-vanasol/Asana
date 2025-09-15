//
//  ProfileImageView.swift
//  Asana
//
//  Created by Kiran T C on 11/09/25.
//

import SwiftUI
import FirebaseAuth

struct ProfileImageView: View {
    var body: some View {
        if let url = Auth.auth().currentUser?.photoURL {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 38, height: 38)
                case .success(let image):
                    image.resizable()
                        .scaledToFill()
                        .frame(width: 38, height: 38)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.white, lineWidth: 1.5)
                        )
                case .failure(_):
                    fallbackImage
                @unknown default:
                    fallbackImage
                }
            }
        } else {
            fallbackImage
        }
    }
    
    private var fallbackImage: some View {
        Image("profile") // fallback asset
            .resizable()
            .scaledToFill()
            .frame(width: 38, height: 38)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.white, lineWidth: 1.5)
            )
    }
}
