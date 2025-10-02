//
//  AsanaItemEntity.swift
//  Asana
//
//  Created by Kiran T C on 30/09/25.
//

import AppIntents

// MARK: - Entity
struct AsanaEntity: AppEntity, Identifiable {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Asana Pose"
    static var defaultQuery = AsanaQuery()

    var id: String
    var name: String
    var viewType: String

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: LocalizedStringResource(stringLiteral: name),
            subtitle: LocalizedStringResource(stringLiteral: viewType.capitalized)
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

    // Yoga + Meditation poses
    static var allAsanas: [AsanaEntity] = [
        AsanaEntity(id: "backpain", name: "Yoga for Back Pain", viewType: "Asana"),
        AsanaEntity(id: "neckpain", name: "Yoga for Neck Pain", viewType: "Asana"),
        AsanaEntity(id: "posture", name: "Yoga for Posture", viewType: "Asana"),
        AsanaEntity(id: "earthmelody", name: "Earth Melodies", viewType: "Meditation"),
        AsanaEntity(id: "innerechoes", name: "Inner Echoes", viewType: "Meditation"),
        AsanaEntity(id: "wavesofbliss", name: "Waves of Bliss", viewType: "Meditation")
    ]
}
