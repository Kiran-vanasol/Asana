//
//  MusicPose.swift
//  Asana
//
//  Created by Kiran T C on 26/09/25.
//

import Foundation

struct MusicPose: Identifiable, Codable {
      let id: String
      let category: String
      let name: String
      let imageURL: String
      let benefits: String
      let caution: String
      let howToPrepare: String
      let sound: String?
      let focusOnThisInstrumentWhen: String?
      let physicalBodyAssociation: String?
      let resonatesWith: String?

    enum CodingKeys: String, CodingKey {
        case id, category, name, imageURL, benefits, caution, howToPrepare
        case sound = "Sound"
        case focusOnThisInstrumentWhen = "FocusonthisInstrumentwhen"
        case physicalBodyAssociation = "PhysicalBodyAssociation"
        case resonatesWith = "Resonateswith"
    }
}


