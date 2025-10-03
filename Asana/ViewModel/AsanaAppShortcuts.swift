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
                "Open \(.applicationName) pose"
            ],
            shortTitle: "Asana Home ",
            systemImageName: "figure.mind.and.body"
        )
                         
                AppShortcut(
                    intent: OpenBackPainIntent(),
                    phrases: [
                        "Open \(.applicationName) Back Pain"
                    ],
                    shortTitle: "Back Pain",
                    systemImageName: "figure.yoga"
                )

                // New direct shortcut: Earth Melody
                AppShortcut(
                    intent: OpenEarthMelodyIntent(),
                    phrases: [
                        "Open \(.applicationName) Earth Melody"
                    ],
                    shortTitle: "Earth Melody",
                    systemImageName: "music.quarternote.3"
                )
    }

    // optional: choose a tile color (iOS 17+)
    static var shortcutTileColor: ShortcutTileColor { .lightBlue }
}

