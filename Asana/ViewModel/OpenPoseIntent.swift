//
//  OpenPoseIntent.swift
//  Asana
//
//  Created by Kiran T C on 02/10/25.
//


import AppIntents
import UIKit

struct OpenPoseIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Pose"
    static var description = IntentDescription("Open a pose in Asana.")
    
    static var openAppWhenRun: Bool = true

    @Parameter(title: "Pose")
    var pose: PoseEntity

    // default initializer used by AppShortcut factory
    init() {
        self.pose = PoseQuery.allPoses.first!
    }
    init(pose: PoseEntity) { self.pose = pose }

    static var parameterSummary: some ParameterSummary {
        Summary("Open \(\.$pose)")
    }

    func perform() async throws -> some IntentResult {
        print("👉 OpenPoseIntent fired — \(pose.name) (\(pose.id))")
        let deepLink = "asana://open/\(pose.id)"
        if let url = URL(string: deepLink) {
            await MainActor.run { UIApplication.shared.open(url) }
        }
        return .result()
    }
}
