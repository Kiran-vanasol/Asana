//
//  StartAsanaIntent.swift
//  Asana
//
//  Created by Kiran T C on 30/09/25.
//
import AppIntents

struct StartAsanaIntent: AppIntent {
    static var title: LocalizedStringResource = "Start Asana Pose"

    @Parameter(title: "Pose")
    var pose: AsanaItemEntity

    static var parameterSummary: some ParameterSummary {
        Summary("Start practicing \(\.$pose)")
    }

    func perform() async throws -> some IntentResult {
        // Handle what happens when Siri/Shortcuts runs this
        return .result(dialog: "Starting \(pose.name) pose 🧘‍♀️")
    }
}
