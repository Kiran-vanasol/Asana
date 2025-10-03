//
//  AsanaAppIntents.swift
//  Asana
//
//  Created by Kiran T C on 01/10/25.
//



import Foundation
import AppIntents

enum AsanaData {
    static let poses: [(id: String, name: String)] = [
        ("backpain", "Yoga for Back Pain"),
        ("neckpain", "Yoga for Neck Pain"),
        ("posture", "Yoga for Posture")
    ]

    static let meditations: [(id: String, name: String)] = [
        ("earthmelody", "Earth Melodies"),
        ("innerechoes", "Inner Echoes"),
        ("wavesofbliss", "Waves of Bliss")
    ]
}

// PoseEntity.swift


struct PoseEntity: AppEntity, Identifiable {
    typealias ID = String
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Pose")
    static var defaultQuery = PoseQuery()

    var id: String
    var name: String

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: LocalizedStringResource(stringLiteral: name))
    }
}

struct PoseQuery: EntityQuery {
    func entities(for identifiers: [PoseEntity.ID]) async throws -> [PoseEntity] {
        Self.allPoses.filter { identifiers.contains($0.id) }
    }
    func suggestedEntities() async throws -> [PoseEntity] {
        Self.allPoses
    }

    static var allPoses: [PoseEntity] {
        AsanaData.poses.map { PoseEntity(id: $0.id, name: $0.name) }
    }
}

// MeditationEntity.swift


struct MeditationEntity: AppEntity, Identifiable {
    typealias ID = String
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Meditation")
    static var defaultQuery = MeditationQuery()

    var id: String
    var name: String

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: LocalizedStringResource(stringLiteral: name))
    }
}

struct MeditationQuery: EntityQuery {
    func entities(for identifiers: [MeditationEntity.ID]) async throws -> [MeditationEntity] {
        Self.allMeditations.filter { identifiers.contains($0.id) }
    }
    func suggestedEntities() async throws -> [MeditationEntity] {
        Self.allMeditations
    }

    static var allMeditations: [MeditationEntity] {
        AsanaData.meditations.map { MeditationEntity(id: $0.id, name: $0.name) }
    }
}
