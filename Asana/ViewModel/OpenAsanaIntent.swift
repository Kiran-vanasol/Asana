//
//  OpenAsanaIntent.swift
//  Asana
//
//  Created by Kiran T C on 01/10/25.
//


import AppIntents
import UIKit

struct OpenAsanaIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Asana Pose"
    static var description = IntentDescription("Open a yoga or meditation session inside the app.")

    @Parameter(title: "Asana")
    var asana: AsanaEntity

    // Provide a default initializer so the AppShortcut can create an instance
    init() {
        // Choose a sane default so the system can instantiate this intent.
        // We use the first item from the static list; safe because it's static data.
        self.asana = AsanaQuery.allAsanas.first!
    }

    // Optional convenience initializer if you want to construct with a specific entity
    init(asana: AsanaEntity) {
        self.asana = asana
    }

    static var parameterSummary: some ParameterSummary {
        Summary("Open \(\.$asana)")
    }

    func perform() async throws -> some IntentResult {
        // debug log so you can confirm it ran
        print("👉 OpenAsanaIntent fired — \(asana.name) (\(asana.id))")

        let deepLink = "asana://open/\(asana.id)"
        if let url = URL(string: deepLink) {
            await MainActor.run {
                UIApplication.shared.open(url)
            }
        }
        return .result()
    }
}

