//
//  ApiPose.swift
//  Asana
//
//  Created by Kiran T C on 10/09/25.
//

// APIPose.swift
import Foundation

struct APIPose: Identifiable, Codable {
    let id: String
    let name: String
    let imageURL: String
    let category: String
//    let localImageName: String?
    
    // Convenience property for AsyncImage
    var url: URL? {
        URL(string: imageURL)
    }

}
