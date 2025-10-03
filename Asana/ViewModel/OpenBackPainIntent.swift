//
//  OpenBackPainIntent.swift
//  Asana
//
//  Created by Kiran T C on 03/10/25.
//


import AppIntents
import UIKit

struct OpenBackPainIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Back Pain Pose"
    static var description = IntentDescription("Directly open the Back Pain yoga view in Asana.")
    static var openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult {
        print("[Intent] OpenBackPainIntent fired")
        let urlString = "asana://open/backpain"
        print(" [Intent] Launching deep link: \(urlString)")

        if let url = URL(string: urlString) {
            await MainActor.run {
                UIApplication.shared.open(url)
            }
        }
        return .result()
    }
}
