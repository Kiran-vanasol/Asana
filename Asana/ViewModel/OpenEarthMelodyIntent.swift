//
//  OpenEarthMelodyIntent.swift
//  Asana
//
//  Created by Kiran T C on 03/10/25.
//


import AppIntents
import UIKit

struct OpenEarthMelodyIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Earth Melody Meditation"
    static var description = IntentDescription("Directly open the Earth Melodies meditation view in Asana.")
    static var openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult {
        print(" [Intent] OpenEarthMelodyIntent fired")
        let urlString = "asana://open/earthmelody"
        print(" [Intent] Launching deep link: \(urlString)")

        if let url = URL(string: urlString) {
            await MainActor.run {
                UIApplication.shared.open(url)
            }
        }
        return .result()
    }
}
