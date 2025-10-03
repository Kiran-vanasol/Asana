//
//  OpenMeditationIntent.swift
//  Asana
//
//  Created by Kiran T C on 02/10/25.
//

import AppIntents
import UIKit

struct OpenMeditationIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Meditation"
    static var description = IntentDescription("Open a meditation in Asana.")
    
    static var openAppWhenRun: Bool = true

    @Parameter(title: "Meditation")
    var meditation: MeditationEntity

    init() {
        self.meditation = MeditationQuery.allMeditations.first!
    }
    init(meditation: MeditationEntity) { self.meditation = meditation }

    static var parameterSummary: some ParameterSummary {
        Summary("Open \(\.$meditation)")
    }

    func perform() async throws -> some IntentResult {
        print(" OpenMeditationIntent fired — \(meditation.name) (\(meditation.id))")
        let deepLink = "asana://open/\(meditation.id)"
        if let url = URL(string: deepLink) {
            await MainActor.run { UIApplication.shared.open(url) }
        }
        return .result()
    }
}
