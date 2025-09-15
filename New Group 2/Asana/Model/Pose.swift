//
//  Pose.swift
//  Asana
//
//  Created by Kiran T C on 09/09/25.
//

import Foundation

// MARK: - Model
struct Pose: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
}

