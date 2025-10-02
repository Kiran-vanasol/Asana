//
//  AsanaAppIntents.swift
//  Asana
//
//  Created by Kiran T C on 01/10/25.
//

import AppIntents

struct AsanaAppShortcuts: AppShortcutsProvider {
    // Use the builder attribute — body should emit AppShortcut items (no surrounding [])
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: OpenAsanaIntent(),
            phrases: [
                "Open \(.applicationName) pose",
                "Start \(.applicationName) \(\.$asana)"
            ],
            shortTitle: "Open Asana",
            systemImageName: "figure.yoga"
        )
    }

    // Optional: pick a tile color (iOS 17+)
    static var shortcutTileColor: ShortcutTileColor {
        .lightBlue
    }
}
