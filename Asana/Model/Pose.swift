//
//  Pose.swift
//  Asana
//
//  Created by Kiran T C on 09/09/25.
//

import Foundation

// MARK: - Model
struct HomeResponse: Codable {
    let asanas: [AsanaItem]
    let meditate: [AsanaItem]
}

struct AsanaItem: Codable, Identifiable {
    var id: String { name }   // for ForEach
    let name: String
    let s3_url: String
    let category: String
}

