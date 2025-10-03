//
//  OpenPoseIntent.swift
//  Asana
//
//  Created by Kiran T C on 02/10/25.
//


import AppIntents
import UIKit

struct OpenPoseIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Asana Home"
    static var description = IntentDescription("Open the Asana home screen.")
    
    static var openAppWhenRun: Bool = true

    
    func perform() async throws -> some IntentResult {
        print(" OpenPoseIntent fired — going to Home")

        return .result()
    }
}
