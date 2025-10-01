//
//  OpenAsanaIntent.swift
//  Asana
//
//  Created by Kiran T C on 01/10/25.
//

import AppIntents
import UIKit

struct OpenAsanaIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Asana"

    @Parameter(title: "Asana Name")
    var asanaName: String

    func perform() async throws -> some IntentResult {
        // Normalize the name
        let normalized = asanaName.lowercased()

        // Build the deep link
        var deepLink: String? = nil
        switch normalized {
        case "backpain": deepLink = "asana://open/backpain"
        case "neckpain": deepLink = "asana://open/neckpain"
        case "posture": deepLink = "asana://open/posture"
        case "earthmelody": deepLink = "asana://open/earthmelody"
        case "innerechoes": deepLink = "asana://open/innerechoes"
        case "wavesofbliss": deepLink = "asana://open/wavesofbliss"
        default: break
        }

        if let deepLink = deepLink, let url = URL(string: deepLink) {
            await MainActor.run {
                UIApplication.shared.open(url)
            }
        }

        return .result()
    }
}
