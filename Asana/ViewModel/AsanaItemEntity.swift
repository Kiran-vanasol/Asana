//
//  AsanaItemEntity.swift
//  Asana
//
//  Created by Kiran T C on 30/09/25.
//

import AppIntents

// Represents a Yoga Pose (Entity) discoverable in Spotlight & Siri
struct AsanaItemEntity: AppEntity {
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Asana Item")
    
    // Spotlight uses this ID to identify items
    var id: String
    
    // Displayed name in Spotlight/Siri
    var name: String
    
    // How the system represents it
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
    
    // Sample data for previews & suggestions
    static var defaultQuery = AsanaItemQuery()
}

struct AsanaItemQuery: EntityQuery {
    func entities(for identifiers: [String]) async throws -> [AsanaItemEntity] {
        // Return poses matching identifiers (for Spotlight deep-linking)
        []
    }

    func suggestedEntities() async throws -> [AsanaItemEntity] {
        // Sample suggested items for Spotlight
        [
            AsanaItemEntity(id: "1", name: "Downward Dog"),
            AsanaItemEntity(id: "2", name: "Lotus Pose"),
            AsanaItemEntity(id: "3", name: "Tree Pose")
        ]
    }
}
