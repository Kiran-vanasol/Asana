//
//  AsanaItemEntity.swift
//  Asana
//
//  Created by Kiran T C on 30/09/25.
//

import AppIntents

// MARK: - Entity
struct AsanaEntity: AppEntity {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Asana"
    static var defaultQuery = AsanaQuery()

    var id: String
    var name: String
    var viewType: String 

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(name)",
            subtitle: "\(viewType.capitalized)"
        )
    }
}

// MARK: - Query
struct AsanaQuery: EntityQuery {
    func entities(for identifiers: [AsanaEntity.ID]) async throws -> [AsanaEntity] {
        Self.allAsanas.filter { identifiers.contains($0.id) }
    }

    func suggestedEntities() async throws -> [AsanaEntity] {
        Self.allAsanas
    }

    // Sample Asanas + Meditations
    static var allAsanas: [AsanaEntity] = [
        AsanaEntity(id: "backpain", name: "Yoga for Back Pain", viewType: "asana"),
        AsanaEntity(id: "neckpain", name: "Yoga for Neck Pain", viewType: "asana"),
        AsanaEntity(id: "posture", name: "Yoga for Posture", viewType: "asana"),
        AsanaEntity(id: "earthmelody", name: "Earth Melodies", viewType: "meditate"),
        AsanaEntity(id: "innerechoes", name: "Inner Echoes", viewType: "meditate"),
        AsanaEntity(id: "wavesofbliss", name: "Waves of Bliss", viewType: "meditate")
    ]
}

