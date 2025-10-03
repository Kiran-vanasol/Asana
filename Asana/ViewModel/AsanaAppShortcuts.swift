//
//  AsanaAppShortcuts.swift
//  Asana
//
//  Created by Kiran T C on 02/10/25.
//

import AppIntents

struct AsanaAppShortcuts: AppShortcutsProvider {
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: OpenPoseIntent(),
            phrases: [
                "Open \(.applicationName) pose",
                "Open \(.applicationName) \(\.$pose)"
            ],
            shortTitle: "Open Pose",
            systemImageName: "figure.yoga"
        )

        AppShortcut(
            intent: OpenMeditationIntent(),
            phrases: [
                "Open \(.applicationName) meditation",
                "Play \(.applicationName) \(\.$meditation)"
            ],
            shortTitle: "Open Meditation",
            systemImageName: "music.note"
        )
    }

    // optional: choose a tile color (iOS 17+)
    static var shortcutTileColor: ShortcutTileColor { .lightBlue }
}

